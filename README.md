# Aura POS

Aplicación móvil de Punto de Venta de nivel empresarial.
Stack: **Flutter · Riverpod · Drift (SQLite) · GoRouter · Material 3**

---

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Arquitectura

```
lib/
├── core/
│   ├── constants/        # AppConstants, PreferenceKeys
│   ├── database/         # AppDatabase (Drift) + tablas
│   ├── di/               # Providers globales (DB, Dio, Hive, SecureStorage)
│   ├── error/            # Failures + Exceptions
│   ├── router/           # GoRouter + RouteNames
│   ├── theme/            # AppTheme M3, AppColors, AppTypography
│   ├── usecase/          # Contrato UseCase
│   ├── utils/            # Formatters, Validators, PinHasher
│   └── widgets/          # StateViews, MainShell
│
└── features/
    ├── auth/             # Login, PIN 6 dígitos, biometría
    ├── dashboard/        # KPIs, acceso rápido, actividad
    ├── pos/              # Grilla productos, escaner, carrito
    ├── customers/        # CRUD clientes, crédito
    ├── payment/          # Efectivo, tarjeta, Nequi, Daviplata, mixto
    ├── receipts/         # Vista previa, compartir
    ├── cash_register/    # Apertura, cierre, arqueo
    ├── products/         # CRUD, variantes, categorías
    ├── inventory/        # Movimientos, Kardex, alertas
    ├── printers/         # Bluetooth/USB/WiFi, ESC/POS
    └── settings/         # Tema, PIN, impresoras
```

---

## Módulos

| # | Módulo              | Estado |
|---|---------------------|--------|
| 1 | Autenticación       | ✅ |
| 2 | Dashboard           | ✅ |
| 3 | Punto de Venta      | ✅ |
| 4 | Carrito             | ✅ |
| 5 | Clientes            | ✅ |
| 6 | Ventas Abiertas     | ✅ |
| 7 | Pago (multi-método) | ✅ |
| 8 | Recibos             | ✅ |
| 9 | Caja                | ✅ |
|10 | Impresoras          | ✅ |
|11 | Inventario / Kardex | ✅ |
|12 | Productos           | ✅ |
|13 | Configuración       | ✅ |
|14 | Sincronización      | ✅ (arquitectura lista) |
|15 | Seguridad           | ✅ |

---

## Notas

- App 100% **offline** (Drift SQLite). No requiere internet.
- Sincronización con FastAPI: arquitectura lista (`sync_queue_items`), servidor pendiente.
- `build_runner` es obligatorio antes del primer `flutter run`.
- Permisos Android completos en `AndroidManifest.xml`.
