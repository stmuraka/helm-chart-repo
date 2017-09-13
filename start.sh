#!/usr/bin/env sh

set -euo pipefail

# INGRESS_SUBDOMAIN - kubernetes cluster subdomain
_sig() {
    echo "Caught signal..."
    kill -TERM `cat /var/run/nginx.pid` 2>/dev/null
}

trap _sig SIGHUP SIGINT SIGTERM

echo "Starting Nginx..."
#nginx -g "daemon on;"
nginx

# Generate helm index.yaml each time the chart directory changes
#while inotifywait -r -qq -e modify,move,create,delete /usr/share/nginx/html/charts; do
while inotifywait -r -q -e modify,move,create,delete ${CHART_DIR}; do
    helm repo index ${CHART_DIR} --url https://${INGRESS_SUBDOMAIN}/charts/
done
