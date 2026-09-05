#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# Aura POS — Setup inicial
# Ejecutar una sola vez después de clonar o extraer el proyecto.
# ─────────────────────────────────────────────────────────────────────────────
set -e

echo "→ flutter pub get"
flutter pub get

echo "→ Generando código (Drift, Freezed, Riverpod, JsonSerializable)…"
dart run build_runner build --delete-conflicting-outputs

echo "✓ Setup completado. Ejecuta: flutter run"
