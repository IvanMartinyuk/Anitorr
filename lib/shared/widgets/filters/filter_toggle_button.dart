import 'package:flutter/material.dart';

class FilterToggleButton extends StatelessWidget {
  const FilterToggleButton({
    required this.count,
    required this.height,
    required this.onPressed,
    super.key,
  });

  final int count;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: height,
      child: Material(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(height / 2),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          tooltip: 'Filters',
          color: colorScheme.onSurfaceVariant,
          onPressed: onPressed,
          icon: Badge(
            isLabelVisible: count > 0,
            label: Text('$count'),
            backgroundColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            child: const Icon(Icons.tune_rounded),
          ),
        ),
      ),
    );
  }
}
