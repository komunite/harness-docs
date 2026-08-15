#!/usr/bin/env bash
# Mintlify içeriğini statik siteye çevirir ve Vercel'in sunacağı dist/
# dizinini hazırlar. Vercel'de buildCommand olarak koşar (bkz. vercel.json);
# local test: bash scripts/build-static.sh && npx serve dist
set -euo pipefail

SITE_URL="${SITE_URL:-https://harness.komunite.com.tr}"

# Önceki build kalıntıları export'a "statik asset" olarak sızmasın
# diye temizlik export'tan ÖNCE yapılır (dist/dist kontaminasyonu).
rm -rf dist export.zip

npx -y mint export --output export.zip

mkdir dist
if command -v unzip >/dev/null 2>&1; then
  unzip -oq export.zip -d dist
elif command -v bsdtar >/dev/null 2>&1; then
  bsdtar -xf export.zip -C dist
else
  python3 -c "import zipfile; zipfile.ZipFile('export.zip').extractall('dist')"
fi
rm -f export.zip

# Local önizleme yardımcıları hosting'de gereksiz.
rm -f dist/serve.js "dist/Start Docs.bat" "dist/Start Docs.command"
rm -rf dist/scripts

# Mintlify "slug/index" sayfalarını "/slug" URL'inde sunar; export ise
# sadece "slug/index/index.html" üretir ve iç linkler "/slug"a işaret
# eder. Sayfayı bir üst dizine kopyalayarak iki URL'i de çalıştır.
find dist -mindepth 2 -type d -name index | while IFS= read -r d; do
  parent=$(dirname "$d")
  [ -f "$parent/index.html" ] || cp "$d/index.html" "$parent/index.html"
done

# Export, custom domain'i bilmediği için OG/canonical URL'lerini
# undefined.mintlify.app olarak basıyor; gerçek domain ile değiştir.
# Statik modda arama Mintlify backend'i istediği için arama UI'ı gizleniyor
# ("Run mint login" mesajı ziyaretçiye gösterilemez).
HIDE_SEARCH_CSS='<style>#search-bar-entry,#search-bar-entry-mobile,[aria-label="Open search"]{display:none !important}</style>'
find dist -name '*.html' -print0 | while IFS= read -r -d '' f; do
  perl -pi -e "s|https://undefined\\.mintlify\\.app|$SITE_URL|g" "$f"
  perl -pi -e "s|</head>|$HIDE_SEARCH_CSS</head>|" "$f"
done

echo "dist/ hazır: $(find dist -name '*.html' | wc -l | tr -d ' ') HTML sayfası"
