# OpenAI structured JSON outputs for taxonomy enrichment

This note summarizes how to reliably enforce JSON output with a schema, and which model is most cost‑effective for our enrichment batches. Sources are official OpenAI docs.

## 1) How to force JSON with a schema (recommended)

Use **Structured Outputs** via `response_format: { type: "json_schema", json_schema: { ... } }`.

Key points from the API reference:
- `response_format` can be set to `json_schema` to enable Structured Outputs and enforce a JSON schema. citeturn2search1
- `strict: true` makes the model always follow the exact schema (only a subset of JSON Schema is supported when strict). citeturn2search1
- `json_object` is the older JSON mode; it only guarantees valid JSON, and still requires an explicit JSON instruction. citeturn2search1

**Recommended request shape (Chat Completions or Responses):**

```json
{
  "model": "gpt-5-nano",
  "messages": [
    { "role": "system", "content": "Return JSON only, matching the schema." },
    { "role": "user", "content": "<your prompt>" }
  ],
  "temperature": 0.2,
  "response_format": {
    "type": "json_schema",
    "json_schema": {
      "name": "taxonomy_match",
      "strict": true,
      "schema": {
        "type": "object",
        "additionalProperties": false,
        "properties": {
          "branch": {
            "type": ["object", "null"],
            "additionalProperties": false,
            "properties": {
              "name": { "type": ["string", "null"] },
              "confidence": { "type": ["number", "null"] }
            },
            "required": ["name", "confidence"]
          },
          "categories": {
            "type": "array",
            "items": {
              "type": "object",
              "additionalProperties": false,
              "properties": {
                "name": { "type": "string" },
                "confidence": { "type": ["number", "null"] }
              },
              "required": ["name", "confidence"]
            }
          }
        },
        "required": ["branch", "categories"]
      }
    }
  }
}
```

## 2) Model choice: cost‑optimal for this task

We need structured outputs + low cost for high‑volume classification. Current OpenAI model docs show the following **text token** pricing (per 1M tokens):

| Model | Input | Output | Structured outputs |
|---|---:|---:|---|
| gpt‑5‑nano | $0.05 | $0.40 | Supported |
| gpt‑5‑mini | $0.25 | $2.00 | Supported |
| gpt‑4.1‑nano | $0.10 | $0.40 | Supported |
| gpt‑4o‑mini | $0.15 | $0.60 | Supported |
| gpt‑4.1‑mini | $0.40 | $1.60 | Supported |
| gpt‑4.1 | $2.00 | $8.00 | Supported |
| gpt‑4o | $2.50 | $10.00 | Supported |

So **gpt‑5‑nano is the lowest‑cost model with Structured Outputs**, which makes it the most cost‑efficient default for bulk enrichment. citeturn0search2turn0search5turn0search1turn1view0

## 3) Implementation changes applied

- Default model switched to **`gpt-5-nano`** in `seed-data/etl/bin/enrich_taxonomy.dart`.
- `seed-data/etl/scripts/run_enrich_taxonomy.sh` now accepts `OPENAI_MODEL` (defaults to `gpt-5-nano`) and passes it to the script.

If we see quality issues, we can switch to another model via:

```bash
OPENAI_MODEL=gpt-4.1-mini
```

or

```bash
OPENAI_MODEL=gpt-4o-mini
```

## 4) Notes / guardrails

- Keep `strict: true` for schema adherence (best for automated ingestion).
- Keep an explicit “return JSON only” instruction even with `json_schema`.
- Avoid models that do **not** support Structured Outputs (e.g., legacy GPT‑4).

## 5) Sources

```
https://platform.openai.com/docs/api-reference/chat/object
https://platform.openai.com/docs/models/gpt-5
https://platform.openai.com/docs/models/gpt-5-mini
https://platform.openai.com/docs/models/gpt-4.1-mini
https://platform.openai.com/docs/models/gpt-4o-mini
https://platform.openai.com/docs/models/gpt-4o
```
