/// Nombres y paths de rutas centralizados para evitar strings mágicos
/// dispersos en la aplicación.
abstract class RouteNames {
  RouteNames._();

  // Auth
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String setupPin = 'setup-pin';
  static const String pinEntry = 'pin-entry';
  static const String pinRecovery = 'pin-recovery';
  static const String switchUser = 'switch-user';

  // Sincronización / TPV
  static const String linkTpv = 'link-tpv';

  // Shell principal
  static const String dashboard = 'dashboard';
  static const String pos = 'pos';
  static const String cart = 'cart';
  static const String openSales = 'open-sales';
  static const String customers = 'customers';
  static const String customerForm = 'customer-form';
  static const String payment = 'payment';
  static const String receiptPreview = 'receipt-preview';
  static const String receiptsHistory = 'receipts-history';

  // Caja
  static const String cashRegister = 'cash-register';
  static const String cashRegisterOpen = 'cash-register-open';
  static const String cashRegisterClose = 'cash-register-close';

  // Inventario / productos
  static const String inventory = 'inventory';
  static const String products = 'products';
  static const String productForm = 'product-form';

  // Configuración
  static const String settings = 'settings';
  static const String printerSettings = 'printer-settings';

  // Cartera / Crédito
  static const String cartera = 'cartera';
  static const String abonoHistory = 'abono-history';
  static const String customerCreditDetail = 'customer-credit-detail';
  static const String abonoForm = 'abono-form';
}

abstract class RoutePaths {
  RoutePaths._();

  static const String login = '/login';
  static const String splash = '/splash';
  static const String register = '/register';
  static const String setupPin = '/setup-pin';
  static const String pinEntry = '/pin-entry';
  static const String pinRecovery = '/pin-recovery';
  static const String switchUser = '/switch-user';

  static const String linkTpv = '/link-tpv';

  static const String dashboard = '/dashboard';
  static const String pos = '/pos';
  static const String cart = '/pos/cart';
  static const String openSales = '/pos/open-sales';
  static const String customers = '/customers';
  static const String customerForm = '/customers/form';
  static const String payment = '/pos/payment';
  static const String receiptPreview = '/pos/receipt';
  static const String receiptsHistory = '/receipts';

  static const String cashRegister = '/cash-register';
  static const String cashRegisterOpen = '/cash-register/open';
  static const String cashRegisterClose = '/cash-register/close';

  static const String inventory = '/inventory';
  static const String products = '/products';
  static const String productForm = '/products/form';

  static const String settings = '/settings';
  static const String printerSettings = '/settings/printers';

  // Cartera / Crédito
  static const String cartera = '/cartera';
  static const String abonoHistory = '/cartera/history';
  static const String customerCreditDetail = '/cartera/detail';
  static const String abonoForm = '/cartera/abono';
}
