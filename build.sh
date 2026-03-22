#!/bin/bash
# Build script: reads lagoons.json and inlines it into the HTML template

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE="$SCRIPT_DIR/template.html"
OUTPUT="$SCRIPT_DIR/index.html"
DATA_FILE="/home/user/workspace/lagoons.json"

if [ ! -f "$DATA_FILE" ]; then
  echo "ERROR: $DATA_FILE not found"
  exit 1
fi

if [ ! -f "$TEMPLATE" ]; then
  echo "ERROR: $TEMPLATE not found"
  exit 1
fi

# Read the JSON data
LAGOON_JSON=$(cat "$DATA_FILE")

# Use Python for reliable string replacement (avoids sed issues with large data)
python3 -c "
import sys

with open('$TEMPLATE', 'r') as f:
    template = f.read()

with open('$DATA_FILE', 'r') as f:
    data = f.read().strip()

output = template.replace('__LAGOON_DATA_PLACEHOLDER__', data)

with open('$OUTPUT', 'w') as f:
    f.write(output)

print(f'Build complete: {len(data)} bytes of lagoon data inlined')
print(f'Output: $OUTPUT')
"

echo "Done!"
