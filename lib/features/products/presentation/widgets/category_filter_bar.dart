import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_providers.dart';

class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final filter = ref.watch(productFilterProvider);
    final scheme = Theme.of(context).colorScheme;

    return categoriesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 48,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: [
              // Chip "Todos"
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: const Text('Todos'),
                  selected: filter.categoryId == null,
                  onSelected: (_) => ref
                      .read(productFilterProvider.notifier)
                      .setCategory(null),
                ),
              ),
              ...categories.map(
                (cat) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: cat.iconName != null
                        ? null
                        : CircleAvatar(
                            radius: 8,
                            backgroundColor: _hexColor(cat.colorHex, scheme),
                          ),
                    label: Text(cat.name),
                    selected: filter.categoryId == cat.id,
                    onSelected: (_) => ref
                        .read(productFilterProvider.notifier)
                        .setCategory(
                            filter.categoryId == cat.id ? null : cat.id),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _hexColor(String hex, ColorScheme fallback) {
    try {
      final hexClean = hex.replaceFirst('#', '');
      return Color(int.parse('FF$hexClean', radix: 16));
    } catch (_) {
      return fallback.primary;
    }
  }
}
