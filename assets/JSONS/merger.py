import json
import glob
import random

all_products = []

# Read all JSON files (except all.json itself)
for file in glob.glob("*.json"):
    if file != "all.json":
        with open(file, "r", encoding="utf-8") as f:
            data = json.load(f)
            all_products.extend(data)

# Shuffle the order randomly
random.shuffle(all_products)

# Save combined, shuffled file
with open("all.json", "w", encoding="utf-8") as f:
    json.dump(all_products, f, indent=2, ensure_ascii=False)

print(f"✅ Combined {len(all_products)} items into all.json (shuffled order)")
