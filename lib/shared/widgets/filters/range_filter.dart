import 'package:flutter/material.dart';

class RangeFilter extends StatelessWidget {
  const RangeFilter({
    required this.label,
    required this.values,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
    this.width = 520,
    super.key,
  });

  final String label;
  final RangeValues values;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<RangeValues> onChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final valueLabel =
        '${values.start.toStringAsFixed(1)} - ${values.end.toStringAsFixed(1)}';

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label $valueLabel', style: textTheme.labelLarge),
          RangeSlider(
            values: values,
            min: min,
            max: max,
            divisions: divisions,
            labels: RangeLabels(
              values.start.toStringAsFixed(1),
              values.end.toStringAsFixed(1),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
