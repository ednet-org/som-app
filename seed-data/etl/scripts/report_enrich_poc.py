#!/usr/bin/env python3
import argparse
import json
import os
from statistics import mean, median
from datetime import datetime, timezone


def load_jsonl(path):
    rows = []
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                rows.append(json.loads(line))
            except json.JSONDecodeError:
                continue
    return rows


def safe_mean(values):
    return mean(values) if values else 0.0


def safe_median(values):
    return median(values) if values else 0.0


def compute_metrics(rows, sample_size):
    count = len(rows)
    coverage = count / sample_size if sample_size else 0.0
    category_counts = [len(row.get("categoryIds", []) or []) for row in rows]
    empty_categories = sum(1 for c in category_counts if c == 0)
    branch_existing = sum(1 for row in rows if row.get("branchStatus") == "existing")
    branch_conf = [row.get("branchConfidence") for row in rows if row.get("branchConfidence") is not None]
    cat_conf = [row.get("avgCategoryConfidence") for row in rows if row.get("avgCategoryConfidence") is not None]
    new_cat_counts = [row.get("newCategoryCount", 0) for row in rows]
    existing_cat_counts = [row.get("existingCategoryCount", 0) for row in rows]

    return {
        "suggestions": count,
        "coverage": coverage,
        "avg_categories": safe_mean(category_counts),
        "median_categories": safe_median(category_counts),
        "pct_empty_categories": (empty_categories / count) if count else 0.0,
        "branch_existing_rate": (branch_existing / count) if count else 0.0,
        "avg_branch_confidence": safe_mean(branch_conf),
        "avg_category_confidence": safe_mean(cat_conf),
        "avg_new_categories": safe_mean(new_cat_counts),
        "avg_existing_categories": safe_mean(existing_cat_counts),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dir", default="seed-data/out/poc", help="Directory with model jsonl outputs")
    parser.add_argument("--sample-size", type=int, default=1000, help="Number of companies evaluated per model")
    parser.add_argument("--out", default="seed-data/out/enrich_poc_report.md", help="Output markdown report")
    args = parser.parse_args()

    model_prices = {
        "gpt-5-nano": {"input": 0.05, "output": 0.40},
        "gpt-5-mini": {"input": 0.25, "output": 2.00},
        "gpt-4.1-nano": {"input": 0.10, "output": 0.40},
        "gpt-4.1-mini": {"input": 0.40, "output": 1.60},
        "gpt-4.1": {"input": 2.00, "output": 8.00},
        "gpt-4o-mini": {"input": 0.15, "output": 0.60},
        "gpt-4o": {"input": 2.50, "output": 10.00},
    }

    out_dir = os.path.abspath(args.dir)
    rows_by_model = {}
    for filename in sorted(os.listdir(out_dir)):
        if not filename.endswith(".jsonl"):
            continue
        model = filename.replace(".jsonl", "")
        path = os.path.join(out_dir, filename)
        rows_by_model[model] = load_jsonl(path)

    lines = []
    lines.append("# SOM enrichment model PoC report")
    lines.append("")
    lines.append(f"- Generated: {datetime.now(timezone.utc).isoformat()}")
    lines.append(f"- Sample size per model: {args.sample_size}")
    lines.append("")
    lines.append("## Metrics")
    lines.append("")
    lines.append("| Model | $/1M in | $/1M out | Suggestions | Coverage | Avg cats | Median cats | Empty cats % | Existing branch % | Avg branch conf | Avg cat conf | Avg new cats | Avg existing cats |")
    lines.append("|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|")

    for model, rows in rows_by_model.items():
        metrics = compute_metrics(rows, args.sample_size)
        price = model_prices.get(model, {"input": None, "output": None})
        lines.append(
            "| {model} | {pin} | {pout} | {suggestions} | {coverage:.2%} | {avg_categories:.2f} | {median_categories:.2f} | {pct_empty_categories:.2%} | {branch_existing_rate:.2%} | {avg_branch_confidence:.2f} | {avg_category_confidence:.2f} | {avg_new_categories:.2f} | {avg_existing_categories:.2f} |".format(
                model=model,
                pin="-" if price["input"] is None else f'{price["input"]:.2f}',
                pout="-" if price["output"] is None else f'{price["output"]:.2f}',
                **metrics,
            )
        )

    lines.append("")
    lines.append("## Notes")
    lines.append("- Coverage = suggestions / sample size (branch null cases are excluded by design).")
    lines.append("- Avg category confidence is computed from model‑reported confidences.")
    lines.append("- Existing branch % indicates how often the model matched an existing branch (vs proposing a new one).")
    lines.append("")
    lines.append("## Pricing sources")
    lines.append("See official OpenAI model docs for pricing and Structured Outputs support.")

    with open(args.out, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")


if __name__ == "__main__":
    main()
