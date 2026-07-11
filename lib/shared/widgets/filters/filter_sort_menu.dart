import 'package:flutter/material.dart';

final class FilterSortOption<T> {
  const FilterSortOption({required this.value, required this.label});

  final T value;
  final String label;
}

class FilterSortMenu<T> extends StatelessWidget {
  const FilterSortMenu({
    required this.value,
    required this.options,
    required this.showLabel,
    required this.height,
    required this.onSelected,
    this.embedded = false,
    this.borderRadius,
    super.key,
  });

  final T value;
  final List<FilterSortOption<T>> options;
  final bool showLabel;
  final double height;
  final ValueChanged<T> onSelected;
  final bool embedded;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        for (final option in options)
          MenuItemButton(
            onPressed: () {
              onSelected(option.value);
            },
            trailingIcon: option.value == value
                ? const Icon(Icons.check_rounded)
                : null,
            child: Text(option.label),
          ),
      ],
      builder: (context, controller, child) {
        final selectedOption = options.firstWhere(
          (option) => option.value == value,
          orElse: () => options.first,
        );

        return _FilterSortTrigger(
          label: selectedOption.label,
          showLabel: showLabel,
          height: height,
          embedded: embedded,
          borderRadius: borderRadius,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }
}

class _FilterSortTrigger extends StatelessWidget {
  const _FilterSortTrigger({
    required this.label,
    required this.showLabel,
    required this.height,
    required this.embedded,
    this.borderRadius,
    required this.onPressed,
  });

  final String label;
  final bool showLabel;
  final double height;
  final bool embedded;
  final BorderRadius? borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final radius =
        borderRadius ?? BorderRadius.circular(showLabel ? 8 : height / 2);
    final child = InkWell(
      borderRadius: radius,
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: showLabel ? 12 : 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sort_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    return Tooltip(
      message: 'Sort',
      child: SizedBox(
        height: height,
        width: showLabel ? null : height,
        child: embedded
            ? child
            : Material(
                color: colorScheme.surfaceContainer,
                borderRadius: radius,
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
      ),
    );
  }
}
