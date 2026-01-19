import re
import glob

base = "/Users/slavisam/projects/som-app/seed-data/out/enrichment_gpt41"
pattern = base + "/gpt-4.1_companies_part_*_remaining2.log"
logs = sorted(glob.glob(pattern))

if not logs:
    print("No remaining2 logs found.")
else:
    for f in logs:
        last = None
        applied = None
        with open(f, "r", encoding="utf-8") as fh:
            for line in fh:
                m = re.search(r"totalProcessed=(\d+)", line)
                if m:
                    last = int(m.group(1))
                a = re.search(r"totalApplied=(\d+)", line)
                if a:
                    applied = int(a.group(1))
        name = f.split("/")[-1]
        print(f"{name}: processed={last} applied={applied}")
