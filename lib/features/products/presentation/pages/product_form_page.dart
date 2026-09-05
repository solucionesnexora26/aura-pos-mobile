import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_providers.dart';

class ProductFormPage extends HookConsumerWidget {
  const ProductFormPage({this.productId, super.key});
  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productByIdProvider(productId));
    if (productId != null) {
      return productAsync.when(
        loading: () => const Scaffold(body: AppLoadingView()),
        error: (e, _) => Scaffold(body: AppErrorView(message: e.toString())),
        data: (p) => _ProductFormBody(product: p),
      );
    }
    return const _ProductFormBody(product: null);
  }
}

class _ProductFormBody extends HookConsumerWidget {
  const _ProductFormBody({required this.product});
  final ProductEntity? product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameCtrl = useTextEditingController(text: product?.name ?? '');
    final descCtrl = useTextEditingController(text: product?.description ?? '');
    final skuCtrl = useTextEditingController(text: product?.sku ?? '');
    final barcodeCtrl = useTextEditingController(text: product?.barcode ?? '');
    final priceCtrl = useTextEditingController(
        text: product != null ? product!.price.toStringAsFixed(0) : '');
    final costCtrl = useTextEditingController(
        text: product != null ? product!.cost.toStringAsFixed(0) : '0');
    final taxCtrl = useTextEditingController(
        text: product != null ? product!.taxRate.toString() : '0');
    final stockCtrl = useTextEditingController(
        text: product != null ? product!.stockQuantity.toString() : '0');
    final lowStockCtrl = useTextEditingController(
        text: product != null ? product!.lowStockThreshold.toString() : '5');

    final selectedCategory = useState<String?>(product?.categoryId);
    final selectedBrand = useState<String?>(product?.brandId);
    final selectedSupplier = useState<String?>(product?.supplierId);
    final unitType = useState(product?.unitType ?? ProductUnitTypeEntity.unit);
    final trackStock = useState(product?.trackStock ?? true);
    final imagePath = useState<String?>(product?.imagePath);
    final isSaving = useState(false);
    final error = useState<String?>(null);

    final categoriesAsync = ref.watch(categoriesProvider);
    final brandsAsync = ref.watch(brandsProvider);
    final suppliersAsync = ref.watch(suppliersProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isRemote = imagePath.value != null &&
        (imagePath.value!.startsWith('http://') ||
            imagePath.value!.startsWith('https://'));

    Future<void> save() async {
      if (!formKey.currentState!.validate()) return;
      isSaving.value = true;
      error.value = null;
      final entity = ProductEntity(
        id: product?.id ?? const Uuid().v4(),
        name: nameCtrl.text.trim(),
        description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
        sku: skuCtrl.text.trim().isEmpty ? null : skuCtrl.text.trim(),
        barcode: barcodeCtrl.text.trim().isEmpty ? null : barcodeCtrl.text.trim(),
        categoryId: selectedCategory.value,
        brandId: selectedBrand.value,
        supplierId: selectedSupplier.value,
        price: double.tryParse(priceCtrl.text.replaceAll(',', '.')) ?? 0,
        cost: double.tryParse(costCtrl.text.replaceAll(',', '.')) ?? 0,
        taxRate: double.tryParse(taxCtrl.text.replaceAll(',', '.')) ?? 0,
        unitType: unitType.value,
        trackStock: trackStock.value,
        stockQuantity: double.tryParse(stockCtrl.text.replaceAll(',', '.')) ?? 0,
        lowStockThreshold: double.tryParse(lowStockCtrl.text.replaceAll(',', '.')) ?? 5,
        hasVariants: false,
        isFavorite: product?.isFavorite ?? false,
        isActive: product?.isActive ?? true,
        imagePath: imagePath.value,
        createdAt: product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final result = product == null
          ? await ref.read(createProductUseCaseProvider).call(entity)
          : await ref.read(updateProductUseCaseProvider).call(entity);
      isSaving.value = false;
      result.fold(
        (f) => error.value = f.message,
        (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(product == null ? 'Producto creado.' : 'Producto actualizado.'),
            ));
            context.pop();
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product == null ? 'Nuevo Producto' : 'Editar Producto'),
        actions: [
          if (isSaving.value)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.icon(
                onPressed: save,
                icon: const Icon(Icons.check),
                label: const Text('Guardar'),
              ),
            ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (error.value != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(error.value!,
                      style: text.bodyMedium?.copyWith(color: scheme.onErrorContainer)),
                ),

              const _Section('Imagen del producto'),
              _ProductImageField(
                path: imagePath.value,
                onChange: (p) => imagePath.value = p,
                onError: (msg) => error.value = msg,
              ),
              const SizedBox(height: 24),

              const _Section('Información básica'),
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (v) => Validators.required(v, field: 'El nombre'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextFormField(controller: skuCtrl, decoration: const InputDecoration(labelText: 'SKU'))),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(controller: barcodeCtrl, decoration: const InputDecoration(labelText: 'Código de barras'))),
              ]),

              const SizedBox(height: 24),
              const _Section('Precio y costos'),
              Row(children: [
                Expanded(child: TextFormField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Precio *'), validator: Validators.nonEmptyPrice)),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(controller: costCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Costo'))),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(controller: taxCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'IVA (%)'))),
              ]),

              const SizedBox(height: 24),
              const _Section('Unidad y stock'),
              DropdownButtonFormField<ProductUnitTypeEntity>(
                value: unitType.value,
                decoration: const InputDecoration(labelText: 'Tipo de unidad'),
                items: ProductUnitTypeEntity.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                    .toList(),
                onChanged: (v) => unitType.value = v ?? ProductUnitTypeEntity.unit,
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                value: trackStock.value,
                onChanged: (v) => trackStock.value = v,
                title: const Text('Controlar stock'),
                contentPadding: EdgeInsets.zero,
              ),
              if (trackStock.value)
                Row(children: [
                  Expanded(child: TextFormField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock inicial'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: lowStockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Alerta bajo'))),
                ]),

              const SizedBox(height: 24),
              const _Section('Clasificación'),
              categoriesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (cats) => DropdownButtonFormField<String?>(
                  value: selectedCategory.value,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: [const DropdownMenuItem(value: null, child: Text('Sin categoría')), ...cats.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))],
                  onChanged: (v) => selectedCategory.value = v,
                ),
              ),
              const SizedBox(height: 12),
              brandsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (brands) => DropdownButtonFormField<String?>(
                  value: selectedBrand.value,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  items: [const DropdownMenuItem(value: null, child: Text('Sin marca')), ...brands.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name)))],
                  onChanged: (v) => selectedBrand.value = v,
                ),
              ),
              const SizedBox(height: 12),
              suppliersAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (sups) => DropdownButtonFormField<String?>(
                  value: selectedSupplier.value,
                  decoration: const InputDecoration(labelText: 'Proveedor'),
                  items: [const DropdownMenuItem(value: null, child: Text('Sin proveedor')), ...sups.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))],
                  onChanged: (v) => selectedSupplier.value = v,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
          const Divider(height: 8),
        ],
      ),
    );
  }
}

class _ProductImageField extends StatelessWidget {
  const _ProductImageField({
    required this.path,
    required this.onChange,
    required this.onError,
  });

  final String? path;
  final ValueChanged<String?> onChange;
  final ValueChanged<String> onError;

  Future<void> _pickImage(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      final file = result?.files.single;
      if (file == null || file.path == null) return;

      final docsDir = await getApplicationDocumentsDirectory();
      final imagesDir =
          Directory('${docsDir.path}${Platform.pathSeparator}product_images');
      await imagesDir.create(recursive: true);

      final ext =
          (file.extension ?? 'jpg').toLowerCase().replaceAll('.', '');
      final dest =
          '${imagesDir.path}${Platform.pathSeparator}${const Uuid().v4()}.$ext';
      await File(file.path!).copy(dest);

      if (context.mounted) onChange(dest);
    } catch (e) {
      onError('No se pudo cargar la imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final p = path;
    final isRemote =
        p != null && (p.startsWith('http://') || p.startsWith('https://'));
    final hasLocal = p != null && !isRemote && File(p).existsSync();
    final hasImage = isRemote || hasLocal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: isRemote
                ? Image.network(
                    p!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: scheme.surfaceContainerHighest,
                      child: Icon(Icons.broken_image_outlined,
                          size: 48, color: scheme.onSurfaceVariant),
                    ),
                  )
                : hasLocal
                    ? Image.file(File(p!), fit: BoxFit.cover)
                    : Container(
                        color: scheme.surfaceContainerHighest,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined,
                                size: 48, color: scheme.onSurfaceVariant),
                            const SizedBox(height: 8),
                            Text(
                              'Sin imagen',
                              style: text.bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(context),
                icon: const Icon(Icons.photo_library_outlined, size: 18),
                label: Text(hasImage ? 'Cambiar imagen' : 'Elegir imagen'),
              ),
            ),
            if (hasImage) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => onChange(null),
                icon: const Icon(Icons.delete_outline),
                color: scheme.error,
                tooltip: 'Quitar imagen',
              ),
            ],
          ],
        ),
      ],
    );
  }
}
