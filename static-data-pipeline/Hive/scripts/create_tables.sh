#!/usr/bin/env bash
set -euo pipefail


echo "✅ HiveServer2 is up, creating tables …"

beeline -u jdbc:hive2://localhost:10000 -n hive -e "
CREATE EXTERNAL TABLE IF NOT EXISTS mbti_labels (
  id BIGINT,
  mbti_personality STRING,
  pers_id BIGINT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/app/data/csv'
TBLPROPERTIES ('skip.header.line.count'='1');

CREATE EXTERNAL TABLE IF NOT EXISTS users1 (
  screen_name STRING,
  location STRING,
  verified BOOLEAN,
  statuses_count INT,
  total_retweet_count INT,
  total_favorite_count INT,
  total_hashtag_count INT,
  total_mentions_count INT,
  total_media_count INT,
  id BIGINT
)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/app/data/jsonl/users1';

CREATE EXTERNAL TABLE IF NOT EXISTS edges1 (
  id BIGINT,
  follows ARRAY<BIGINT>,
  is_followed_by ARRAY<BIGINT>
)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/app/data/jsonl/edges1';
"

echo "✅  Hive tables created."




