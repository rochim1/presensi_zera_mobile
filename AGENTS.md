# Pantoo HR release builds

- For production APK/AAB, use `pwsh -File scripts/build-release.ps1 -Artifact apk|aab|all` (choose one value). The script cleans, rebuilds production web, validates its version, then builds Android.
- Never commit/push deletions of `build/web` caused by `flutter clean`. If manually invoking clean, rebuild production web before Android delivery/push; restore the prior web output if rebuilding fails.
- Keep APK/AAB ignored. `build/web` is intentionally tracked for server pull deployment.
- Enable the repository guard with `git config core.hooksPath .githooks`. Stage updated web output with the release changes. Do not auto-commit unrelated user changes.
