# Contributing

PRs welcome. Keep the hook fast and dependency-free by default.

## Testing locally

```bash
chmod +x hooks/pre-commit scripts/*.sh
./scripts/install.sh .
# Stage a fake secret in a test file and verify the hook blocks the commit.
```
