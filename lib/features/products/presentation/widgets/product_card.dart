import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_providers.dart';

/// Detecta si una ruta de imagen es una URL remota (Storage de Supabase) o un
/// archivo local.
bool _isRemote(String path) => path.startsWith('http://') || path.startsWith('https://');

class ProductCard extends ConsumerWidget {
  const ProductCard({required this.product, super.key});
  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final imagePath = product.imagePath;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.goNamed(
          RouteNames.productForm,
          queryParameters: {'id': product.id},
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen / placeholder
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imagePath != null && _isRemote(imagePath))
                    Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(scheme),
                    )
                  else if (imagePath != null)
                    Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(scheme),
                    )
                  else
                    _placeholder(scheme),
                  // Badge de stock bajo
                  if (product.isLowStock)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: product.isOutOfStock
                              ? scheme.error
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.isOutOfStock ? 'Sin stock' : 'Stock bajo',
                          style: text.labelSmall?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  // Botón favorito
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: _FavoriteButton(product: product),
                  ),
                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppFormatters.currency(product.price),
                    style: text.titleSmall?.copyWith(color: scheme.primary),
                  ),
                  if (product.trackStock)
                    Text(
                      '${AppFormatters.quantity(product.stockQuantity)} en stock',
                      style: text.bodySmall?.copyWith(
                        color: product.isLowStock
                            ? scheme.error
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme scheme) {
    return Container(
      color: scheme.surfaceContainerHighest,
      child: Icon(
        Icons.inventory_2_outlined,
        size: 40,
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref
          .read(toggleFavoriteUseCaseProvider)
          .call(product.id),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          product.isFavorite ? Icons.star : Icons.star_outline,
          size: 18,
          color: product.isFavorite ? Colors.amber : Colors.white,
        ),
      ),
    );
  }
}
