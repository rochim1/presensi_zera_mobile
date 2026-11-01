run_dev:
	fvm flutter run --flavor development -t lib/main_development.dart

build_runner:
	fvm dart run build_runner build --delete-conflicting-outputs

build_runner_data:
	cd packages/presensi_data && fvm dart run build_runner build --delete-conflicting-outputs

build_dev:
	fvm flutter build apk --debug --flavor development --target lib/main_development.dart

build_staging:
	pwsh -File scripts/build-release.ps1 -Artifact apk

build_aab:
	pwsh -File scripts/build-release.ps1 -Artifact aab
