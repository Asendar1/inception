#!/bin/sh

set -e

echo "Launching Adminer database GUI on port 8080..."

exec php83 -S 0.0.0.0:8080 -t /var/www/adminer
