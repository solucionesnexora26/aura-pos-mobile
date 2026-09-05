import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/pin_entry_page.dart';
import '../../features/auth/presentation/pages/pin_recovery_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/setup_pin_page.dart';
import '../../features/auth/presentation/pages/switch_user_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/cash_register/presentation/pages/cash_register_close_page.dart';
import '../../features/cash_register/presentation/pages/cash_register_open_page.dart';
import '../../features/cash_register/presentation/pages/cash_register_page.dart';
import '../../features/customers/presentation/pages/customer_form_page.dart';
import '../../features/customers/presentation/pages/customers_page.dart';
import '../../features/credit/presentation/pages/abono_form_page.dart';
import '../../features/credit/presentation/pages/abono_history_page.dart';
import '../../features/credit/presentation/pages/cartera_page.dart';
import '../../features/credit/presentation/pages/customer_credit_detail_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/pos/presentation/pages/open_sales_page.dart';
import '../../features/pos/presentation/pages/pos_page.dart';
import '../../features/printers/presentation/pages/printer_settings_page.dart';
import '../../features/products/presentation/pages/product_form_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/receipts/presentation/pages/receipt_preview_page.dart';
import '../../features/receipts/presentation/pages/receipts_history_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/sync/presentation/pages/link_tpv_page.dart';
import '../widgets/app_exit_guard.dart';
import '../widgets/main_shell.dart';
import '../widgets/splash_page.dart';
import 'route_names.dart';

/// Router raíz de Aura POS. La protección de rutas (redirect) exige sesión
/// activa para cualquier ruta fuera del flujo de autenticación, cumpliendo
/// el requisito de seguridad de "protección de rutas".
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((ref) {
  // Re-evalúa el redirect ante cada cambio de sesión (restauración en segundo
  // plano al arrancar, login, logout, PIN configurado). Sin esto, el router
  // queda pegado en /login porque no escucha los cambios de authSessionProvider.
  final ValueNotifier<int> authRefresh = ValueNotifier<int>(0);
  ref.listen(authSessionProvider, (_, __) => authRefresh.value++);
  // Al terminar la restauración de sesión, el redirect decide a qué pantalla
  // ir (PIN, login o dashboard) saliendo del /splash de arranque.
  ref.listen(sessionLoadedProvider, (_, __) => authRefresh.value++);
  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: authRefresh,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final AuthSessionState session = ref.read(authSessionProvider);

      // Arranque: espera a que la sesión guardada se restaure antes de decidir
      // a dónde ir, evitando que aparezca la pantalla de login sin necesidad.
      if (!ref.read(sessionLoadedProvider)) {
        if (state.matchedLocation != RoutePaths.splash) {
          return RoutePaths.splash;
        }
        return null;
      }

      final bool loggingIn = state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.setupPin ||
          state.matchedLocation == RoutePaths.pinEntry ||
          state.matchedLocation == RoutePaths.pinRecovery;

      // Hay un usuario recordado localmente pero aún no desbloquea con PIN.
      final bool hasRememberedUser = session.user != null && !session.isAuthenticated;

      // Usuario autenticado pero aún debe configurar PIN.
      if (session.requiresPinSetup) {
        if (state.matchedLocation != RoutePaths.setupPin) {
          return RoutePaths.setupPin;
        }
        return null;
      }

      if (!session.isAuthenticated && !loggingIn) {
        if (hasRememberedUser) {
          return RoutePaths.pinEntry;
        }
        return RoutePaths.login;
      }
      if (session.isAuthenticated && loggingIn) {
        return RoutePaths.dashboard;
      }
      // Si hay usuario recordado y está en login/register, ir a PIN.
      if (hasRememberedUser &&
          (state.matchedLocation == RoutePaths.login ||
              state.matchedLocation == RoutePaths.register)) {
        return RoutePaths.pinEntry;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const AppExitGuard(child: LoginPage()),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const AppExitGuard(child: RegisterPage()),
      ),
      GoRoute(
        path: RoutePaths.setupPin,
        name: RouteNames.setupPin,
        builder: (context, state) => const AppExitGuard(child: SetupPinPage()),
      ),
      GoRoute(
        path: RoutePaths.pinEntry,
        name: RouteNames.pinEntry,
        builder: (context, state) => const AppExitGuard(child: PinEntryPage()),
      ),
      GoRoute(
        path: RoutePaths.pinRecovery,
        name: RouteNames.pinRecovery,
        builder: (context, state) => const AppExitGuard(child: PinRecoveryPage()),
      ),
      GoRoute(
        path: RoutePaths.switchUser,
        name: RouteNames.switchUser,
        builder: (context, state) => const AppExitGuard(child: SwitchUserPage()),
      ),
      GoRoute(
        path: RoutePaths.linkTpv,
        name: RouteNames.linkTpv,
        builder: (context, state) => const LinkTpvPage(),
      ),

      // Shell con navegación principal (adaptativo: rail en tablet, bar en teléfono)
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.dashboard,
            name: RouteNames.dashboard,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: RoutePaths.pos,
            name: RouteNames.pos,
            builder: (context, state) => const PosPage(),
            routes: [
              GoRoute(
                path: 'open-sales',
                name: RouteNames.openSales,
                builder: (context, state) => const OpenSalesPage(),
              ),
              GoRoute(
                path: 'payment',
                name: RouteNames.payment,
                builder: (context, state) => const PaymentPage(),
              ),
              GoRoute(
                path: 'receipt',
                name: RouteNames.receiptPreview,
                builder: (context, state) => ReceiptPreviewPage(
                  saleId: state.uri.queryParameters['saleId'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.customers,
            name: RouteNames.customers,
            builder: (context, state) => const CustomersPage(),
            routes: [
              GoRoute(
                path: 'form',
                name: RouteNames.customerForm,
                builder: (context, state) => CustomerFormPage(
                  customerId: state.uri.queryParameters['id'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.cashRegister,
            name: RouteNames.cashRegister,
            builder: (context, state) => const CashRegisterPage(),
            routes: [
              GoRoute(
                path: 'open',
                name: RouteNames.cashRegisterOpen,
                builder: (context, state) => const CashRegisterOpenPage(),
              ),
              GoRoute(
                path: 'close',
                name: RouteNames.cashRegisterClose,
                builder: (context, state) => const CashRegisterClosePage(),
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.inventory,
            name: RouteNames.inventory,
            builder: (context, state) => const InventoryPage(),
          ),
          GoRoute(
            path: RoutePaths.products,
            name: RouteNames.products,
            builder: (context, state) => const ProductsPage(),
            routes: [
              GoRoute(
                path: 'form',
                name: RouteNames.productForm,
                builder: (context, state) => ProductFormPage(
                  productId: state.uri.queryParameters['id'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.settings,
            name: RouteNames.settings,
            builder: (context, state) => const SettingsPage(),
            routes: [
              GoRoute(
                path: 'printers',
                name: RouteNames.printerSettings,
                builder: (context, state) => const PrinterSettingsPage(),
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.receiptsHistory,
            name: RouteNames.receiptsHistory,
            builder: (context, state) => const ReceiptsHistoryPage(),
          ),

          // ── Cartera / Crédito ────────────────────────────────────────
          GoRoute(
            path: RoutePaths.cartera,
            name: RouteNames.cartera,
            builder: (context, state) => const CarteraPage(),
            routes: [
              GoRoute(
                path: 'history',
                name: RouteNames.abonoHistory,
                builder: (context, state) => const AbonoHistoryPage(),
              ),
              GoRoute(
                path: 'detail',
                name: RouteNames.customerCreditDetail,
                builder: (context, state) {
                  final params = state.uri.queryParameters;
                  return CustomerCreditDetailPage(
                    customerId: params['customerId'] ?? '',
                    customerName: params['customerName'],
                  );
                },
              ),
              GoRoute(
                path: 'abono',
                name: RouteNames.abonoForm,
                builder: (context, state) {
                  final params = state.uri.queryParameters;
                  return AbonoFormPage(
                    customerId: params['customerId'] ?? '',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
