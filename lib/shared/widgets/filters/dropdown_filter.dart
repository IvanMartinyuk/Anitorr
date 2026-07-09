import 'package:flutter/material.dart';

import 'filter_option.dart';

class DropdownFilter<T> extends StatelessWidget {
  const DropdownFilter({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.width = 220,
    super.key,
  });

  final String label;
  final T value;
  final List<FilterOption<T>> options;
  final ValueChanged<T?> onChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ).copyWith(labelText: label),
        items: [
          for (final option in options)
            DropdownMenuItem<T>(
              value: option.value,
              child: Text(option.label, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
