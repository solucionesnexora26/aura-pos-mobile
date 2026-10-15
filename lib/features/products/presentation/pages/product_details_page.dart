import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_providers.dart';

class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productByIdProvider(productId));
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del producto'),
        leading: IconButton(
          tooltip: 'Volver a productos',
          onPressed: () => context.goNamed(RouteNames.products),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _MessageView(
          icon: Icons.error_outline,
          message: 'No se pudieron cargar los detalles del producto.',
          detail: error.toString(),
        ),
        data: (product) {
          if (product == null) {
            return const _MessageView(
              icon: Icons.inventory_2_outlined,
              message: 'No se encontró el producto en el catálogo local.',
            );
          }
          return _ProductDetails(product: product);
        },
      ),
      floatingActionButton: null,
      backgroundColor: colors.surface,
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final imagePath = product.imagePath;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: imagePath == null
                    ? ColoredBox(
                        color: colors.surfaceContainerHighest,
                        child: Icon(Icons.inventory_2_outlined,
                            size: 56, color: colors.onSurfaceVariant),
                      )
                    : imagePath.startsWith('http://') ||
                            imagePath.startsWith('https://')
                        ? Image.network(imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _imagePlaceholder(colors))
                        : Image.file(File(imagePath),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _imagePlaceholder(colors)),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _StatusChip(
                            label: product.isActive ? 'Activo' : 'Inactivo',
                            active: product.isActive),
                        if (product.isFavorite)
                          const _StatusChip(
                              label: 'Favorito',
                              icon: Icons.star,
                              active: true),
                        if (product.hasVariants)
                          const _StatusChip(
                              label: 'Con variantes',
                              icon: Icons.widgets_outlined,
                              active: false),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(product.name,
                        style: text.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    if (product.description?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Text(product.description!,
                          style: text.bodyMedium
                              ?.copyWith(color: colors.onSurfaceVariant)),
                    ],
                    const SizedBox(height: 18),
                    Text(AppFormatters.currency(product.price),
                        style: text.headlineMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _DetailsSection(
          title: 'Identificación',
          children: [
            _DetailTile(
                label: 'SKU',
                value:
                    product.sku?.isNotEmpty == true ? product.sku! : 'Sin SKU',
                icon: Icons.qr_code_2),
            _DetailTile(
                label: 'Código de barras',
                value: product.barcode?.isNotEmpty == true
                    ? product.barcode!
                    : 'Sin código de barras',
                icon: Icons.qr_code_scanner),
            _DetailTile(
                label: 'Categoría',
                value: product.category?.name ?? 'Sin categoría',
                icon: Icons.category_outlined),
            _DetailTile(
                label: 'Marca',
                value: product.brand?.name ?? 'Sin marca',
                icon: Icons.sell_outlined),
            _DetailTile(
                label: 'Proveedor',
                value: product.supplier?.name ?? 'Sin proveedor',
                icon: Icons.local_shipping_outlined),
          ],
        ),
        const SizedBox(height: 14),
        _DetailsSection(
          title: 'Precio e inventario',
          children: [
            _DetailTile(
                label: 'Precio de venta',
                value: AppFormatters.currency(product.price),
                icon: Icons.sell_outlined),
            _DetailTile(
                label: 'Costo',
                value: AppFormatters.currency(product.cost),
                icon: Icons.payments_outlined),
            _DetailTile(
                label: 'Impuesto',
                value: '${AppFormatters.quantity(product.taxRate)}%',
                icon: Icons.percent),
            _DetailTile(
                label: 'Unidad de venta',
                value: product.unitType.label,
                icon: Icons.straighten),
            _DetailTile(
              label: 'Control de inventario',
              value: product.trackStock ? 'Controlado' : 'No controlado',
              icon: Icons.inventory_outlined,
            ),
            if (product.trackStock) ...[
              _DetailTile(
                  label: 'Existencias',
                  value: AppFormatters.quantity(product.stockQuantity),
                  icon: Icons.warehouse_outlined),
              _DetailTile(
                  label: 'Alerta de stock bajo',
                  value: AppFormatters.quantity(product.lowStockThreshold),
                  icon: Icons.warning_amber_outlined),
            ],
          ],
        ),
        if (product.variants.isNotEmpty) ...[
          const SizedBox(height: 14),
          _DetailsSection(
            title: 'Variantes (${product.variants.length})',
            children: product.variants
                .map((variant) => _DetailTile(
                      label: variant.name,
                      value:
                          '${AppFormatters.currency(product.price + variant.priceDelta)} · ${AppFormatters.quantity(variant.stockQuantity)} en stock',
                      icon: Icons.widgets_outlined,
                    ))
                .toList(),
          ),
        ],
        const SizedBox(height: 16),
        Center(
          child: Text('Vista de solo consulta',
              style:
                  text.labelMedium?.copyWith(color: colors.onSurfaceVariant)),
        ),
      ],
    );
  }

  Widget _imagePlaceholder(ColorScheme colors) => ColoredBox(
        color: colors.surfaceContainerHighest,
        child: Icon(Icons.broken_image_outlined,
            size: 56, color: colors.onSurfaceVariant),
      );
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              ...children,
            ],
          ),
        ),
      );
}

class _DetailTile extends StatelessWidget {
  const _DetailTile(
      {required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 19, color: colors.onSurfaceVariant),
      title: Text(label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: colors.onSurfaceVariant)),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 190),
        child: Text(value,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, this.icon, required this.active});

  final String label;
  final IconData? icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = active ? colors.primary : colors.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5)
        ],
        Text(label,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.icon, required this.message, this.detail});

  final IconData icon;
  final String message;
  final String? detail;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon,
                size: 42,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            if (detail != null) ...[
              const SizedBox(height: 6),
              Text(detail!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ]),
        ),
      );
}
