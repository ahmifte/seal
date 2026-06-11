#!/usr/bin/env bash
# Install seal into every project repo under ~/projects.
set -euo pipefail

SEAL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"

REPOS=(folio flowforge distill pathfinder aikit)

for repo in "${REPOS[@]}"; do
  path="$PROJECTS_DIR/$repo"
  if [[ -d "$path/.git" ]]; then
    echo "Installing seal into $repo..."
    "$SEAL_DIR/scripts/install.sh" "$path"
  else
    echo "Skipping $repo (not a git repo at $path)"
  fi
done

echo "Done."
