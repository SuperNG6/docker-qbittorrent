#!/usr/bin/env bash
set -Eeuo pipefail

image=${1:?Image is required}
platform=${2:?Platform is required}
container="qbittorrent-search-smoke-$$"
webui=http://127.0.0.1:18080

cleanup() {
    local status=$?
    if ((status != 0)); then
        docker logs --tail 60 "$container" 2>&1 |
            sed -E 's/(temporary password[^:]*:|临时密码：).*/\1 [redacted]/I' >&2 || true
    fi
    docker rm -fv "$container" >/dev/null 2>&1 || true
}
trap cleanup EXIT

docker run -d --name "$container" --pull never --platform "$platform" --network none \
    -e UT=false -e WEBUI_PORT=18080 "$image" >/dev/null

request() {
    docker exec -i "$container" curl --noproxy '*' -fsS --max-time 8 \
        -H "Referer: $webui/" "$@"
}

for _ in {1..45}; do
    if request "$webui/" >/dev/null 2>&1; then break; fi
    sleep 1
done
request "$webui/" >/dev/null
password=$(docker logs "$container" 2>&1 |
    sed -nE 's/.*(temporary password[^:]*:|临时密码：) *([^[:space:]]+).*/\2/Ip' | tail -n 1)
[[ -n "$password" ]]
printf 'username=admin&password=%s' "$password" |
    request -c /tmp/search-smoke-cookie --data-binary @- "$webui/api/v2/auth/login" >/dev/null

api() {
    request -b /tmp/search-smoke-cookie "$@"
}

api "$webui/api/v2/search/plugins" |
    jq -e 'any(.[]; .name == "tokyotoshokan" and .fullName == "Tokyo Toshokan")' >/dev/null

docker exec -i --user abc "$container" sh -c 'cat > /tmp/searchsmoke.py' <<'PY'
# VERSION: 1.0
from urllib.parse import unquote

from novaprinter import prettyPrinter


class searchsmoke:
    name = "Search Smoke Test"
    url = "https://example.invalid"
    supported_categories = {"all": "all"}

    def search(self, query, category="all"):
        if unquote(query) == "search smoke":
            prettyPrinter({
                "link": self.url + "/fixture.torrent",
                "name": "Search smoke fixture",
                "size": "1 MB",
                "seeds": 1,
                "leech": 0,
                "engine_url": self.url,
            })
PY

api --data-urlencode 'sources=/tmp/searchsmoke.py' "$webui/api/v2/search/installPlugin" >/dev/null
job=$(api --data-urlencode 'pattern=search smoke' --data-urlencode 'category=all' \
    --data-urlencode 'plugins=searchsmoke' "$webui/api/v2/search/start" | jq -er '.id')
for _ in {1..30}; do
    results=$(api "$webui/api/v2/search/results?id=$job")
    if jq -e '.status == "Stopped"' <<<"$results" >/dev/null; then break; fi
    sleep 1
done
jq -e '.status == "Stopped" and .total == 1 and
    .results[0].fileName == "Search smoke fixture" and .results[0].fileSize == 1048576' \
    <<<"$results" >/dev/null
printf '%s (%s) passed WebUI plugin discovery and search\n' "$image" "$platform"
