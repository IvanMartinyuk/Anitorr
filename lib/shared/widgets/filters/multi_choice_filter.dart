import 'package:flutter/material.dart';

import 'filter_option.dart';

class MultiChoiceFilter<T> extends StatelessWidget {
  const MultiChoiceFilter({
    required this.options,
    required this.selectedValues,
    required this.onToggle,
    this.spacing = 8,
    super.key,
  });

  final List<FilterOption<T>> options;
  final Set<T> selectedValues;
  final ValueChanged<T> onToggle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (final option in options)
          FilterChip(
            label: Text(option.label),
            selected: selectedValues.contains(option.value),
            onSelected: (_) => onToggle(option.value),
          ),
      ],
    );
  }
}

class LabeledMultiChoiceFilter<T> extends StatelessWidget {
  const LabeledMultiChoiceFilter({
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onToggle,
    this.spacing = 8,
    super.key,
  });

  final String label;
  final List<FilterOption<T>> options;
  final Set<T> selectedValues;
  final ValueChanged<T> onToggle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge),
        const SizedBox(height: 8),
        MultiChoiceFilter<T>(
          options: options,
          selectedValues: selectedValues,
          onToggle: onToggle,
          spacing: spacing,
        ),
      ],
    );
  }
}
