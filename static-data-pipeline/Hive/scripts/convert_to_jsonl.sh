#!/usr/bin/env bash
set -euo pipefail

echo "Transforming JSON files to JSONL format..."

DATA_DIR="${DATA_DIR:-/app/data}"

# ---------- users1.json -----------------------------------------------------
if [[ -f "$DATA_DIR/users1.json" ]]; then
  echo "🔄  users1.json  →  users1_lines.jsonl"
  jq -c '.[]' "$DATA_DIR/users1.json" \
      > "$DATA_DIR/users1_lines.jsonl"
fi

# ---------- edges1.json -----------------------------------------------------
if [[ -f "$DATA_DIR/edges1.json" ]]; then
  echo "🔄  edges1.json  →  edges1_lines.jsonl"
  jq -c 'map({
        id,
        follows: (if (.follows | type) == "string"
                  then (.follows | split(",") | map(tonumber))
                  else .follows end),
        is_followed_by: (if (.is_followed_by | type) == "string"
                         then (.is_followed_by | split(",") | map(tonumber))
                         else .is_followed_by end)
      })[]' "$DATA_DIR/edges1.json" \
      > "$DATA_DIR/edges1_lines.jsonl"
fi


echo "✅  Conversion completed successfully!"

echo "Organising files into data directory..."

mkdir -p "$DATA_DIR/jsonl"
mkdir -p "$DATA_DIR/jsonl/users1"
mkdir -p "$DATA_DIR/jsonl/edges1"
mkdir -p "$DATA_DIR/csv"

cp "$DATA_DIR/mbti_labels.csv" "$DATA_DIR/csv/mbti_labels.csv"
mv "$DATA_DIR/users1_lines.jsonl" "$DATA_DIR/jsonl/users1/users1_lines.jsonl"
mv "$DATA_DIR/edges1_lines.jsonl" "$DATA_DIR/jsonl/edges1/edges1_lines.jsonl"

echo "✅  Files organised successfully!"



