#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$ROOT"

# fnpack requires real PNG files. Generate minimal valid 1x1 PNG icons when
# release artwork has not been added yet.
if [ ! -f ICON.PNG ] || [ ! -f ICON_256.PNG ]; then
  python3 - <<'PY'
import base64
png = base64.b64decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=')
for name in ('ICON.PNG', 'ICON_256.PNG'):
    open(name, 'wb').write(png)
PY
fi

command -v fnpack >/dev/null 2>&1 || { echo 'fnpack introuvable'; exit 1; }
fnpack build --directory "$ROOT"
