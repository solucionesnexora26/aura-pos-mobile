# Local mobile_scanner patch

This package is based on upstream `mobile_scanner` 5.2.3. The public Dart API is
unchanged.

## Android CameraX resolution fallback

Some CameraX/OEM combinations return `null` from `ImageAnalysis.resolutionInfo`
after binding. Upstream force-unwrapped this nullable platform property during
scanner startup, which could surface as a native `NullPointerException` and
leave the QR scanner unusable. Startup now falls back to Preview's negotiated
resolution, then CameraX's documented default analysis size (640x480).

Keep the forked dependency override in the app's `pubspec.yaml`; replacing it
with the hosted package removes this compatibility fix.
