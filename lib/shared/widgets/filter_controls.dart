import 'package:flutter/material.dart';

final class FilterOption<T> {
  const FilterOption({required this.value, required this.label});

  final T value;
  final String label;
}

class FilterPanel extends StatelessWidget {
  const FilterPanel({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class FilterRow extends StatelessWidget {
  const FilterRow({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}

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
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        items: [
          for (final option in options)
            DropdownMenuItem<T>(value: option.value, child: Text(option.label)),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class TextSearchFilter extends StatefulWidget {
  const TextSearchFilter({
    required this.label,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.borderless = false,
    this.width = 280,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final bool borderless;
  final double width;

  @override
  State<TextSearchFilter> createState() => _TextSearchFilterState();
}

class _TextSearchFilterState extends State<TextSearchFilter> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(TextSearchFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return SizedBox(
      width: widget.width,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: widget.borderless ? InputBorder.none : border,
          enabledBorder: widget.borderless ? InputBorder.none : border,
          focusedBorder: widget.borderless
              ? InputBorder.none
              : border.copyWith(
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
          labelText: widget.label,
          hintText: widget.hintText,
          contentPadding: widget.borderless
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
              : const EdgeInsets.symmetric(horizontal: 16),
          suffixIcon: _controller.text.isEmpty
              ? const Icon(Icons.search_rounded)
              : IconButton(
                  tooltip: 'Clear ${widget.label.toLowerCase()} filter',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    setState(_controller.clear);
                    widget.onChanged('');
                  },
                ),
        ),
        onChanged: (value) {
          setState(() {});
          widget.onChanged(value);
        },
      ),
    );
  }
}

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
