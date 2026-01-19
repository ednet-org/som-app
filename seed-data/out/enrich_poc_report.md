# SOM enrichment model PoC report

- Generated: 2026-01-18T20:29:12.935161+00:00
- Sample size per model: 1000

## Metrics

| Model | $/1M in | $/1M out | Suggestions | Coverage | Avg cats | Median cats | Empty cats % | Existing branch % | Avg branch conf | Avg cat conf | Avg new cats | Avg existing cats |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| gpt-4.1-mini | 0.40 | 1.60 | 256 | 25.60% | 0.02 | 0.00 | 98.44% | 100.00% | 0.87 | 0.83 | 0.00 | 0.02 |
| gpt-4.1-nano | 0.10 | 0.40 | 382 | 38.20% | 3.00 | 3.00 | 0.00% | 100.00% | 0.00 | 0.00 | 0.02 | 2.98 |
| gpt-4.1 | 2.00 | 8.00 | 884 | 88.40% | 0.67 | 1.00 | 40.05% | 100.00% | 0.84 | 0.66 | 0.00 | 0.67 |
| gpt-4o-mini | 0.15 | 0.60 | 341 | 34.10% | 0.00 | 0.00 | 100.00% | 99.71% | 0.90 | 0.00 | 0.00 | 0.00 |
| gpt-4o | 2.50 | 10.00 | 779 | 77.90% | 0.01 | 0.00 | 98.59% | 100.00% | 0.89 | 0.80 | 0.00 | 0.01 |
| gpt-5-mini | 0.25 | 2.00 | 0 | 0.00% | 0.00 | 0.00 | 0.00% | 0.00% | 0.00 | 0.00 | 0.00 | 0.00 |
| gpt-5-nano | 0.05 | 0.40 | 0 | 0.00% | 0.00 | 0.00 | 0.00% | 0.00% | 0.00 | 0.00 | 0.00 | 0.00 |

## Notes
- Coverage = suggestions / sample size (branch null cases are excluded by design).
- Avg category confidence is computed from model‑reported confidences.
- Existing branch % indicates how often the model matched an existing branch (vs proposing a new one).

## Pricing sources
See official OpenAI model docs for pricing and Structured Outputs support.
