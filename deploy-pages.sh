#!/bin/bash
# deploy-pages.sh — 发布展示站到 Cloudflare Pages（边缘托管，去掉"回源北京"这一段）
#
# 用法：
#   bash deploy-pages.sh --build-only     # 只生成 pages-dist（无需凭据）
#   CLOUDFLARE_API_TOKEN=xxx bash deploy-pages.sh
#
# 一次性准备见 PAGES-DEPLOY.md

set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="$ROOT/pages-dist"

rm -rf "$OUT"
mkdir -p "$OUT"
for f in index.html data.json favicon.svg _headers; do
    [ -f "$ROOT/$f" ] && cp "$ROOT/$f" "$OUT/"
done
[ -d "$ROOT/logos" ] && cp -r "$ROOT/logos" "$OUT/"
[ -f "$ROOT/mo-logo.svg" ] && cp "$ROOT/mo-logo.svg" "$OUT/"

echo "dist: $OUT"
ls -la "$OUT"

if [ "${1:-}" = "--build-only" ]; then
    echo "✅ 构建完成（未发布）"
    exit 0
fi

if ! command -v wrangler >/dev/null 2>&1; then
    echo "❌ 未安装 wrangler：npm i -g wrangler" >&2
    exit 2
fi
if [ -z "${CLOUDFLARE_API_TOKEN:-}" ]; then
    echo "❌ 未设置 CLOUDFLARE_API_TOKEN（需 Pages:Edit 权限）" >&2
    exit 3
fi

wrangler pages deploy "$OUT" \
    --project-name="${PAGES_PROJECT:-mo-showcase}" \
    --branch=main \
    --commit-dirty=true
