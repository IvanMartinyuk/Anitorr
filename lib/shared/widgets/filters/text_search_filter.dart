import 'package:flutter/material.dart';

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
