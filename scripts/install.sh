#!/usr/bin/env bash
# Install seal's pre-commit hook into the current git repository.
set -euo pipefail

TARGET="${1:-.}"
TARGET="$(cd "$TARGET" && pwd)"
SEAL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [[ ! -d "$TARGET/.git" ]]; then
  echo "error: $TARGET is not a git repository" >&2
  exit 1
fi

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "error: gitleaks is required but not installed" >&2
  echo "  brew install gitleaks" >&2
  echo "  https://github.com/gitleaks/gitleaks#installing" >&2
  exit 1
fi

HOOKS_DIR="$TARGET/.githooks"
mkdir -p "$HOOKS_DIR"

cp "$SEAL_DIR/hooks/pre-commit" "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-commit"

# Copy gitleaks config so the hook can find it when SEAL_DIR isn't set.
cp "$SEAL_DIR/gitleaks.toml" "$HOOKS_DIR/gitleaks.toml"

git -C "$TARGET" config core.hooksPath .githooks

# Append common secret paths to .gitignore when missing.
GITIGNORE="$TARGET/.gitignore"
touch "$GITIGNORE"
MISSING=()
for entry in ".env" ".env.local" ".env.*.local" "credentials.json" "*.pem"; do
  if ! grep -qF "$entry" "$GITIGNORE" 2>/dev/null; then
    MISSING+=("$entry")
  fi
done
if [[ ${#MISSING[@]} -gt 0 ]]; then
  {
    echo ""
    echo "# seal — never commit secrets"
    printf '%s\n' "${MISSING[@]}"
  } >> "$GITIGNORE"
fi

echo "seal installed in $TARGET"
echo "  hook: .githooks/pre-commit"
echo "  config: core.hooksPath=.githooks"
echo "  gitleaks: $(gitleaks version 2>/dev/null | head -1 || echo 'installed')"
