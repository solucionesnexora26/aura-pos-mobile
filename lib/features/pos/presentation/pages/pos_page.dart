import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../products/presentation/widgets/category_filter_bar.dart';
import '../providers/pos_providers.dart';
import '../widgets/cart_panel.dart';
import '../widgets/cart_summary_bar.dart';
import '../widgets/product_quantity_badge.dart';
import '../widgets/quantity_editor_sheet.dart';

class PosPage extends HookConsumerWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCtrl = useTextEditingController();
    final productsAsync = ref.watch(productsStreamProvider);
    final cart = ref.watch(cartProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 840;

    useEffect(() {
      void listener() =>
          ref.read(productFilterProvider.notifier).setSearch(searchCtrl.text);
      searchCtrl.addListener(listener);
      return () => searchCtrl.removeListener(listener);
    }, []);

    final productGrid = Column(
      children: [
        // Header barra de búsqueda
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Row(
            children: [
              Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Buscar producto o escanear código…',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () => _openScanner(context, ref),
                        ),
                        if (searchCtrl.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchCtrl.clear();
                              ref.read(productFilterProvider.notifier).setSearch('');
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () => context.goNamed(RouteNames.openSales),
                icon: Badge(
                  isLabelVisible: ref.watch(openSalesStreamProvider).valueOrNull?.isNotEmpty ?? false,
                  child: const Icon(Icons.receipt_long_outlined),
                ),
                tooltip: 'Ventas abiertas',
              ),
            ],
          ),
        ),
        const CategoryFilterBar(),
        Expanded(
          child: productsAsync.when(
            loading: () => const AppLoadingView(message: 'Cargando productos…'),
            error: (e, _) => AppErrorView(message: e.toString()),
            data: (products) {
              final available = products.where((p) => !p.isOutOfStock).toList();
              if (available.isEmpty) {
                return const AppEmptyView(
                  message: 'No hay productos disponibles en este TPV.',
                  icon: Icons.inventory_2_outlined,
                );
              }
              return _PosProductGrid(
                products: available,
                bottomPadding: isWide || cart.isEmpty ? 12 : 96,
              );
            },
          ),
        ),
      ],
    );

    if (isWide) {
      return Scaffold(
        drawer: const AppDrawer(),
        body: Row(
          children: [
            Expanded(flex: 3, child: productGrid),
            const VerticalDivider(width: 1),
            SizedBox(width: 380, child: const CartPanel()),
          ],
        ),
      );
    }

    return Scaffold(
      drawer: const AppDrawer(),
      body: productGrid,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: cart.isEmpty
          ? null
          : CartSummaryBar(
              lineCount: cart.items.length,
              unitCount: cart.itemCount,
              total: cart.total,
              onTap: () => _showCartSheet(context),
            ),
    );
  }

  void _openScanner(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _ScannerSheet(ref: ref),
    );
  }

  void _showCartSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 1,
        expand: false,
        builder: (context, scrollController) => const CartPanel(),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Grilla de productos
// ═════════════════════════════════════════════════════════════════════════════

class _PosProductGrid extends ConsumerWidget {
  const _PosProductGrid({required this.products, this.bottomPadding = 12});
  final List<ProductEntity> products;
  final double bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = switch (width) {
      >= 1200 => 5,
      >= 840 => 4,
      >= 600 => 3,
      _ => 2,
    };
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottomPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) => _PosProductTile(product: products[i]),
    );
  }
}

class _PosProductTile extends ConsumerWidget {
  const _PosProductTile({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final outOfStock = product.isOutOfStock;
    final selected = ref.watch(cartProvider.select(
      (c) => (c.quantityForProduct(product.id), c.itemForProduct(product.id)?.id),
    ));
    final qty = selected.$1;
    final itemId = selected.$2;
    final showBadge = !product.hasVariants && qty > 0 && itemId != null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: outOfStock
            ? null
            : () {
                if (product.hasVariants && product.variants.isNotEmpty) {
                  _showVariantSheet(context, ref, product);
                } else {
                  final added =
                      ref.read(cartProvider.notifier).addProduct(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(added
                          ? '${product.name} agregado'
                          : 'Stock máximo alcanzado para ${product.name}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: scheme.surfaceContainerHighest,
                    child: Icon(Icons.inventory_2_outlined, size: 40, color: scheme.onSurfaceVariant),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: text.labelSmall),
                      const SizedBox(height: 4),
                      Text(AppFormatters.currency(product.price),
                          style: text.labelMedium?.copyWith(color: scheme.primary)),
                    ],
                  ),
                ),
              ],
            ),
            if (showBadge)
              Positioned(
                top: 8,
                right: 8,
                child: ProductQuantityBadge(
                  quantity: qty,
                  onTap: () => _openQtyEditor(context, ref, itemId),
                ),
              ),
            if (outOfStock)
              Container(
                color: Colors.black45,
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Sin stock', style: text.labelSmall?.copyWith(color: scheme.onError)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openQtyEditor(BuildContext context, WidgetRef ref, String itemId) async {
    final cart = ref.read(cartProvider);
    final item = cart.itemForProduct(product.id);
    if (item == null) return;
    final maxQty =
        !product.trackStock ? double.infinity : product.stockQuantity;
    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => QuantityEditorSheet(
        productName: item.displayName,
        initialQuantity: item.quantity,
        maxQuantity: maxQty,
      ),
    );
    if (result == null) return;
    ref.read(cartProvider.notifier).updateQuantity(item.id, result);
  }

  void _showVariantSheet(BuildContext context, WidgetRef ref, ProductEntity product) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ...product.variants.map(
              (v) => ListTile(
                title: Text(v.name),
                trailing: Text(AppFormatters.currency(product.priceForVariant(v))),
                onTap: () {
                  final added = ref
                      .read(cartProvider.notifier)
                      .addProduct(product, variant: v);
                  Navigator.of(context).pop();
                  if (!added) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Stock máximo alcanzado para ${v.name}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerSheet extends HookConsumerWidget {
  const _ScannerSheet({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(MobileScannerController.new);
    useEffect(() {
      return controller.dispose;
    }, [controller],);

    return MobileScanner(
      controller: controller,
      onDetect: (capture) async {
        final barcode = capture.barcodes.firstOrNull?.rawValue;
        if (barcode == null) return;
        await controller.stop();
        final result = await ref.read(getProductByBarcodeUseCaseProvider).call(barcode);
        result.fold(
          (_) {},
          (product) {
            if (product != null) {
              ref.read(cartProvider.notifier).addProduct(product);
            }
          },
        );
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}
