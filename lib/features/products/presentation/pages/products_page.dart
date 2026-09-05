import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/utils/excel_utils.dart';
import '../providers/product_providers.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/product_card.dart';

class ProductsPage extends HookConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCtrl = useTextEditingController();
    final productsAsync = ref.watch(productsStreamProvider);
    final filter = ref.watch(productFilterProvider);

    useEffect(() {
      void listener() =>
          ref.read(productFilterProvider.notifier).setSearch(searchCtrl.text);
      searchCtrl.addListener(listener);
      return () => searchCtrl.removeListener(listener);
    }, []);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('Productos'),
        actions: [
          IconButton(
            tooltip: 'Favoritos',
            icon: Icon(
              filter.onlyFavorites ? Icons.star : Icons.star_outline,
              color: filter.onlyFavorites
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onPressed: () =>
                ref.read(productFilterProvider.notifier).toggleFavorites(),
          ),
          PopupMenuButton<String>(
            tooltip: 'Opciones',
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'download_template') {
                await ExcelUtils.downloadTemplate();
              } else if (value == 'import') {
                _importProducts(context, ref);
              } else if (value == 'new_product') {
                context.goNamed(RouteNames.productForm);
              } else if (value == 'delete_all') {
                await _deleteAllProducts(context, ref);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'new_product',
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Nuevo producto'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'download_template',
                child: ListTile(
                  leading: Icon(Icons.download_outlined),
                  title: Text('Descargar plantilla Excel'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: ListTile(
                  leading: Icon(Icons.upload_file_outlined),
                  title: Text('Importar productos'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'delete_all',
                child: ListTile(
                  leading: Icon(Icons.delete_forever, color: Colors.red),
                  title: Text('Eliminar todos (temporal)',
                      style: TextStyle(color: Colors.red)),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, SKU o código de barras…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchCtrl.clear();
                          ref.read(productFilterProvider.notifier).setSearch('');
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const CategoryFilterBar(),
          Expanded(
            child: productsAsync.when(
              loading: () =>
                  const AppLoadingView(message: 'Cargando productos…'),
              error: (e, _) => AppErrorView(message: e.toString()),
              data: (products) {
                final filtered = filter.onlyFavorites
                    ? products.where((p) => p.isFavorite).toList()
                    : products;
                if (filtered.isEmpty) {
                  return AppEmptyView(
                    message: filter.searchQuery != null
                        ? 'Sin resultados para "${filter.searchQuery}"'
                        : 'No hay productos. Toca + para agregar uno.',
                    icon: Icons.inventory_2_outlined,
                    actionLabel: 'Agregar producto',
                    onAction: () => context.goNamed(RouteNames.productForm),
                  );
                }
                return _ProductGrid(products: filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAllProducts(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar todos los productos'),
        content: const Text(
          'Se borrarán TODOS los productos del dispositivo. '
          'Esta acción no se puede deshacer.\n\n'
          '¿Continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar todo'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final db = ref.read(appDatabaseProvider);
    await db.transaction(() async {
      await db.delete(db.productVariants).go();
      await db.delete(db.products).go();
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los productos eliminados')),
      );
    }
  }

  Future<void> _importProducts(BuildContext context, WidgetRef ref) async {
    Uint8List? fileBytes;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      fileBytes = result.files.first.bytes;

      if (fileBytes == null && result.files.first.path != null) {
        final file = File(result.files.first.path!);
        fileBytes = await file.readAsBytes();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar archivo: $e')),
        );
      }
      return;
    }

    if (fileBytes == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo leer el archivo.')),
        );
      }
      return;
    }

    if (!context.mounted) return;

    late final List<Map<String, dynamic>> products;
    try {
      products = await ExcelUtils.importFromExcel(fileBytes);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al procesar Excel: $e')),
        );
      }
      return;
    }

    if (!context.mounted) return;

    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron productos en el archivo.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Importar ${products.length} productos'),
        content: Text(
          'Se encontraron ${products.length} productos.\n\n¿Deseas importarlos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Importar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      int saved = 0;
      for (final p in products) {
        final entity = ProductEntity(
          id: p['id'] as String,
          name: p['name'] as String,
          description: p['description'] as String?,
          sku: p['sku'] as String?,
          barcode: p['barcode'] as String?,
          categoryId: null,
          brandId: null,
          supplierId: null,
          price: (p['price'] as num).toDouble(),
          cost: (p['cost'] as num).toDouble(),
          taxRate: (p['taxRate'] as num).toDouble(),
          unitType: p['unitType'] as ProductUnitTypeEntity,
          trackStock: p['trackStock'] as bool,
          stockQuantity: (p['stockQuantity'] as num).toDouble(),
          lowStockThreshold: (p['lowStockThreshold'] as num).toDouble(),
          hasVariants: p['hasVariants'] as bool,
          isFavorite: false,
          isActive: p['isActive'] as bool,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final result = await ref.read(createProductUseCaseProvider).call(entity);
        result.fold((f) {}, (_) => saved++);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$saved de ${products.length} productos importados.'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});
  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = switch (width) {
      >= 1200 => 5,
      >= 840 => 4,
      >= 600 => 3,
      _ => 2,
    };
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}
