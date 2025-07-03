#!/usr/bin/env bash
set -euo pipefail

/usr/local/bin/convert_to_jsonl.sh

# start HiveServer2 in the background
/entrypoint.sh hiveserver2 &
HS2_PID=$!

# wait for HiveServer2 to be ready
echo "⏳ Waiting for HiveServer2 on localhost:10000 …"
until nc -z localhost 10000; do
    sleep 2
done

/usr/local/bin/create_tables.sh

wait $HS2_PID   # keep container alive on HiveServer2