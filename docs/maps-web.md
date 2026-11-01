# Google Maps Web — Pantoo HR

Updated: 2026-11-01

- Google Cloud project: `pantoo-511802`, managed by `adminpantoo@gmail.com`.
- Key name: `Pantoo HR Maps Web Production and Development`.
- Key resource: `0ad22771-f300-47b1-8d3c-11acba503307`.
- API restriction: Maps JavaScript API only; API enabled in this project.
- Website restrictions: `https://*.pantoo.id/*`, `http://localhost/*`, `http://127.0.0.1/*`.
- Browser key is configured in `web/index.html` and copied into `build/web/index.html` by Flutter. This is a public browser key protected by the restrictions above; do not use it as a backend or Android credential.

Production web build:

```powershell
flutter build web --release --target lib/main_production.dart
```

Output: `build/web`. Upload the contents to the Pantoo HR web host; this build does not deploy itself.

Validation: production build succeeded. A standalone map loaded real Google Maps tiles successfully from both `http://localhost:8767` and `http://127.0.0.1:8767` with the new restricted key. This verifies development origins on a non-default port, not a deployed production end-to-end attendance flow.

Additional Flutter validation: the actual `AppMapView` widget rendered Google Maps tiles, a marker and a radius circle in Chrome at `http://localhost:8767`. Its `onMapReady` callback completed. The check-in/check-out pages and optional location-only widget passed Flutter analysis with no issues. This does not submit an attendance record or verify a newly installed Android binary.

Pantoo HR uses Google Maps on mobile and web, including check-in and check-out. `HRMS_WEB_GOOGLE_MAPS` defaults to `true`, so a normal web build displays the attendance map. An explicit `--dart-define=HRMS_WEB_GOOGLE_MAPS=false` retains the optional location-only mode. Coordinates and server-side attendance rules remain unchanged.

The separate Vue admin application retains its existing Mapbox GL pages (including organization and pharmacy location management). Do not replace those Mapbox integrations globally. The browser Maps key does not replace Android/iOS Maps keys or change OAuth login clients.
