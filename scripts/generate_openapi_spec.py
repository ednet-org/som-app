import json
import re
from pathlib import Path
from typing import Dict, List, Tuple

API_DIR = Path('openapi/lib/src/api')
MODEL_DIR = Path('openapi/lib/src/model')

EXCLUDE_API_FILES = {'authentication_api.dart'}

DART_TYPE_MAP = {
    'String': {'type': 'string'},
    'int': {'type': 'integer'},
    'double': {'type': 'number'},
    'num': {'type': 'number'},
    'bool': {'type': 'boolean'},
    'DateTime': {'type': 'string', 'format': 'date-time'},
    'Date': {'type': 'string', 'format': 'date'},
}


def _strip_nullable(type_name: str) -> Tuple[str, bool]:
    t = type_name.strip()
    if t.endswith('?'):
        return t[:-1].strip(), True
    return t, False


def _extract_inner_type(type_name: str) -> str:
    return type_name[type_name.find('<') + 1:type_name.rfind('>')].strip()


def _pascal_case(name: str) -> str:
    parts = name.replace('.dart', '').split('_')
    return ''.join(p[:1].upper() + p[1:] for p in parts if p)


def load_model_names() -> List[str]:
    names = []
    for path in MODEL_DIR.glob('*.dart'):
        if path.name.endswith('.g.dart'):
            continue
        names.append(_pascal_case(path.name))
    return names


def parse_enum_blocks(text: str) -> Dict[str, List[int]]:
    enum_blocks: Dict[str, List[int]] = {}
    class_matches = list(re.finditer(r'class\s+(\w+)\s+extends\s+EnumClass', text))
    for idx, match in enumerate(class_matches):
        name = match.group(1)
        start = match.end()
        end = class_matches[idx + 1].start() if idx + 1 < len(class_matches) else len(text)
        block = text[start:end]
        values = [
            int(m.group(1))
            for m in re.finditer(r'@BuiltValueEnumConst\(wireNumber:\s*(\d+)\)', block)
        ]
        if values:
            deduped = list(dict.fromkeys(values))
            enum_blocks[name] = deduped
    return enum_blocks


def parse_model_fields(text: str) -> List[Tuple[str, str, bool]]:
    fields = []
    pattern = re.compile(
        r"@BuiltValueField\(wireName: r'([^']+)'\)\s+([A-Za-z0-9_<>,\?\s]+)\s+get\s+([A-Za-z0-9_]+);",
        re.MULTILINE,
    )
    for match in pattern.finditer(text):
        wire_name = match.group(1)
        raw_type = match.group(2).strip()
        base_type, nullable = _strip_nullable(raw_type)
        fields.append((wire_name, base_type, nullable))
    return fields


def build_schema(type_name: str, model_names: List[str], enum_map: Dict[str, List[int]]):
    base_type, _ = _strip_nullable(type_name)
    if base_type.startswith('BuiltList<') or base_type.startswith('BuiltSet<'):
        inner = _extract_inner_type(base_type)
        return {
            'type': 'array',
            'items': build_schema(inner, model_names, enum_map),
        }
    if base_type in DART_TYPE_MAP:
        return DART_TYPE_MAP[base_type]
    if base_type in enum_map:
        return {'type': 'integer', 'enum': enum_map[base_type]}
    if base_type in model_names:
        return {'$ref': f'#/components/schemas/{base_type}'}
    # Fallback for unknown types
    return {'type': 'object'}


def build_components_schemas() -> Dict[str, dict]:
    model_names = load_model_names()
    enum_map: Dict[str, List[int]] = {}
    schemas: Dict[str, dict] = {}

    # Gather enums by class name
    for path in MODEL_DIR.glob('*.dart'):
        if path.name.endswith('.g.dart'):
            continue
        text = path.read_text()
        enum_map.update(parse_enum_blocks(text))

    for path in MODEL_DIR.glob('*.dart'):
        if path.name.endswith('.g.dart'):
            continue
        model_name = _pascal_case(path.name)
        text = path.read_text()
        fields = parse_model_fields(text)
        if not fields:
            # Enum-only or helper files are not emitted as components to avoid
            # generating standalone enum models without part files.
            continue

        properties = {}
        required = []
        for wire_name, base_type, nullable in fields:
            properties[wire_name] = build_schema(base_type, model_names, enum_map)
            if not nullable:
                required.append(wire_name)

        schema = {
            'type': 'object',
            'properties': properties,
        }
        if required:
            schema['required'] = required
        schemas[model_name] = schema

    return schemas


def parse_api_methods() -> Dict[str, dict]:
    paths: Dict[str, dict] = {}

    for api_file in API_DIR.glob('*.dart'):
        if api_file.name in EXCLUDE_API_FILES:
            continue
        text = api_file.read_text()
        class_match = re.search(r'class\s+(\w+)Api', text)
        tag = class_match.group(1) if class_match else api_file.stem

        func_pattern = re.compile(r'Future<Response<([^>]+)>>\s+(\w+)\(', re.MULTILINE)
        matches = list(func_pattern.finditer(text))
        for idx, match in enumerate(matches):
            start = match.start()
            end = matches[idx + 1].start() if idx + 1 < len(matches) else len(text)
            block = text[start:end]

            response_type = match.group(1).strip()
            method_match = re.search(r"method: r'([A-Z]+)'", block)
            path_match = re.search(r"_path = r'([^']+)'", block)
            if not method_match or not path_match:
                continue
            http_method = method_match.group(1).lower()
            path = path_match.group(1)

            # security
            secure_match = re.search(r"'secure': <Map<String, String>>\[(.*?)\]", block, re.DOTALL)
            secured = bool(secure_match and secure_match.group(1).strip())

            # query parameters
            query_params = []
            for qmatch in re.finditer(r"r'([^']+)': encodeQueryParameter\(_serializers, [^,]+, const FullType\(([^)]+)\)\)", block):
                name = qmatch.group(1)
                qtype = qmatch.group(2).strip()
                query_params.append((name, qtype))

            # request body
            request_body = None
            if "contentType: 'multipart/form-data'" in block:
                form_keys = re.findall(r"r'([^']+)': file", block)
                properties = {key: {'type': 'string', 'format': 'binary'} for key in form_keys}
                request_body = {
                    'content': {
                        'multipart/form-data': {
                            'schema': {
                                'type': 'object',
                                'properties': properties,
                            }
                        }
                    }
                }
            else:
                body_match = re.search(r'const _type = FullType\((\w+)\);', block)
                if body_match:
                    body_model = body_match.group(1)
                    request_body = {
                        'content': {
                            'application/json': {
                                'schema': {'$ref': f'#/components/schemas/{body_model}'},
                            }
                        }
                    }

            # response schema
            def response_schema(resp_type: str):
                resp_type = resp_type.strip()
                if resp_type == 'void':
                    return None
                if resp_type.startswith('BuiltList<'):
                    inner = _extract_inner_type(resp_type)
                    return {'type': 'array', 'items': {'$ref': f'#/components/schemas/{inner}'}}
                if resp_type in DART_TYPE_MAP:
                    return DART_TYPE_MAP[resp_type]
                return {'$ref': f'#/components/schemas/{resp_type}'}

            responses = {'200': {'description': 'Success'}}
            schema = response_schema(response_type)
            if schema is not None:
                responses['200']['content'] = {
                    'application/json': {'schema': schema},
                    'text/json': {'schema': schema},
                }

            parameters = []
            # path params from template
            for param in re.findall(r'\{([^}]+)\}', path):
                parameters.append({
                    'name': param,
                    'in': 'path',
                    'required': True,
                    'schema': {'type': 'string'},
                })
            for name, qtype in query_params:
                param_schema = DART_TYPE_MAP.get(qtype, {'type': 'string'})
                parameters.append({
                    'name': name,
                    'in': 'query',
                    'required': False,
                    'schema': param_schema,
                })

            operation = {
                'tags': [tag],
                'responses': responses,
            }
            if parameters:
                operation['parameters'] = parameters
            if request_body is not None:
                operation['requestBody'] = request_body
            if secured:
                operation['security'] = [{'BearerAuth': []}]

            paths.setdefault(path, {})[http_method] = operation

    return paths


def build_spec() -> dict:
    schemas = build_components_schemas()
    paths = parse_api_methods()
    return {
        'openapi': '3.0.1',
        'info': {
            'title': 'SOM Platform API',
            'version': 'v1',
        },
        'servers': [
            {'url': 'http://localhost:8080'},
        ],
        'paths': dict(sorted(paths.items())),
        'components': {
            'schemas': schemas,
            'securitySchemes': {
                'BearerAuth': {
                    'type': 'http',
                    'scheme': 'bearer',
                }
            },
        },
    }


def main() -> None:
    spec = build_spec()
    Path('openapi/openapi.json').write_text(json.dumps(spec, indent=2))
    Path('swagger.json').write_text(json.dumps(spec, indent=2))


if __name__ == '__main__':
    main()
