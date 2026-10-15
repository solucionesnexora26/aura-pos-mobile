import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/product_entity.dart';
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
            tooltip: filter.onlyFavorites ? 'Mostrar todos' : 'Ver favoritos',
            icon: Icon(
              filter.onlyFavorites ? Icons.star : Icons.star_outline,
              color: filter.onlyFavorites
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onPressed: () =>
                ref.read(productFilterProvider.notifier).toggleFavorites(),
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
                          ref
                              .read(productFilterProvider.notifier)
                              .setSearch('');
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
                        : 'No hay productos para mostrar.',
                    icon: Icons.inventory_2_outlined,
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
