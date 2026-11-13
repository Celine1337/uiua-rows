#!/usr/bin/env bash
# Build a launcher at bin/uiua-rows (Uiua is interpreted; no compilation needed).
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p bin
cat > bin/uiua-rows <<'WRAP'
#!/usr/bin/env bash
DIR="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
exec uiua run --no-format "$DIR/src/main.ua" "$@"
WRAP
chmod +x bin/uiua-rows
echo "built bin/uiua-rows"