#!/usr/bin/env bash
set -e

superset db upgrade

# Create the admin user only if it doesn't exist yet
if ! superset fab list-users | grep -q "^admin\b" ; then
  superset fab create-admin \
      --username "${ADMIN_USERNAME:-admin}" \
      --firstname "${ADMIN_FIRSTNAME:-AdminFirstname}" \
      --lastname  "${ADMIN_LASTNAME:-AdminLastname}" \
      --email     "${ADMIN_EMAIL:-admin@admin.com}" \
      --password  "${ADMIN_PASSWORD:-admin}"
fi

superset init
exec superset run -h 0.0.0.0 -p 8088