import json
import subprocess
from pathlib import Path

API_SPEC = Path('api/openapi.yaml')
OPENAPI_JSON = Path('openapi/openapi.json')
SWAGGER_JSON = Path('swagger.json')


def _load_spec_with_pyyaml() -> dict | None:
    try:
        import yaml  # type: ignore
    except Exception:
        return None
    return yaml.safe_load(API_SPEC.read_text())


def _load_spec_with_ruby() -> dict:
    ruby_script = (
        "require 'yaml'; require 'json'; "
        f"puts JSON.pretty_generate(YAML.load_file('{API_SPEC.as_posix()}'))"
    )
    result = subprocess.run(
        ['ruby', '-e', ruby_script],
        check=True,
        capture_output=True,
        text=True,
    )
    return json.loads(result.stdout)


def main() -> None:
    spec = _load_spec_with_pyyaml()
    if spec is None:
        spec = _load_spec_with_ruby()
    payload = json.dumps(spec, indent=2)
    OPENAPI_JSON.write_text(payload)
    SWAGGER_JSON.write_text(payload)


if __name__ == '__main__':
    main()
