# seal

[![CI](https://github.com/ahmifte/seal/actions/workflows/ci.yml/badge.svg)](https://github.com/ahmifte/seal/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

A lightweight, installable **pre-commit hook** that blocks accidental secrets, API keys, and private env files before they reach git.

No framework required — one script, optional [gitleaks](https://github.com/gitleaks/gitleaks) for deep scanning.

## What it catches

- **Blocked files:** `.env`, `.env.local`, `credentials.json`, `*.pem`, private keys
- **Secret patterns (fallback):** Stripe (`sk_`, `rk_`, `whsec_`), OpenAI (`sk-...`), GitHub tokens (`ghp_`, `gho_`, `github_pat_`), AWS (`AKIA...`), Slack (`xox...`)
- **With gitleaks installed:** 100+ additional rules via extended `gitleaks.toml`

`.env.example` and documented placeholders are allowlisted.

## Quick install (any repo)

```bash
git clone https://github.com/ahmifte/seal.git
./seal/scripts/install.sh /path/to/your/repo
```

This sets `core.hooksPath=.githooks`, copies the hook + config, and patches `.gitignore` if needed.

### Install into all five AI projects at once

```bash
./seal/scripts/install-all.sh
```

Expects repos under `~/projects/` (`folio`, `flowforge`, `distill`, `pathfinder`, `aikit`).

## Recommended: install gitleaks

```bash
brew install gitleaks
```

Without it, seal still runs a built-in regex scan. With it, you get full gitleaks coverage on every commit.

## Alternative: pre-commit framework

If you already use [pre-commit](https://pre-commit.com):

```bash
pre-commit install
```

Uses [`.pre-commit-config.yaml`](.pre-commit-config.yaml) with gitleaks + env-file blocking.

## How it works

```mermaid
flowchart TD
  commit[git commit] --> hook[seal pre-commit hook]
  hook --> blockEnv{".env / credentials staged?"}
  blockEnv -->|yes| fail[Block commit]
  blockEnv -->|no| gitleaks{gitleaks installed?}
  gitleaks -->|yes| scan[gitleaks protect --staged]
  gitleaks -->|no| regex[built-in regex scan]
  scan --> pass[Allow commit]
  regex --> pass
  scan -->|secret found| fail
  regex -->|secret found| fail
```

## Uninstall

```bash
git config --unset core.hooksPath
rm -rf .githooks
```

## License

MIT — see [LICENSE](./LICENSE).
