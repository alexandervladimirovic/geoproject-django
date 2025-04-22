#!/usr/bin/env sh

set -e

echo "Run apply migrations.. "
python3 manage.py migrate
echo "Migrations applied!"

exec "$@"