import 'package:flutter/material.dart';

import 'filter_option.dart';

class MultiChoiceFilter<T> extends StatelessWidget {
  const MultiChoiceFilter({
    required this.options,
    required this.selectedValues,
    required this.onToggle,
    this.spacing = 8,
    this.largeListThreshold = 15,
    this.largeListMenuMaxHeight = 320,
    super.key,
  });

  final List<FilterOption<T>> options;
  final Set<T> selectedValues;
  final ValueChanged<T> onToggle;
  final double spacing;
  final int largeListThreshold;
  final double largeListMenuMaxHeight;

  @override
  Widget build(BuildContext context) {
    if (options.length > largeListThreshold) {
      return _SearchableMultiChoiceFilter<T>(
        options: options,
        selectedValues: selectedValues,
        onToggle: onToggle,
        spacing: spacing,
        menuMaxHeight: largeListMenuMaxHeight,
      );
    }

    return _SelectedOptionChips<T>(
      options: options,
      selectedValues: selectedValues,
      onToggle: onToggle,
      spacing: spacing,
      showUnselected: true,
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
    this.largeListThreshold = 15,
    this.largeListMenuMaxHeight = 320,
    super.key,
  });

  final String label;
  final List<FilterOption<T>> options;
  final Set<T> selectedValues;
  final ValueChanged<T> onToggle;
  final double spacing;
  final int largeListThreshold;
  final double largeListMenuMaxHeight;

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
          largeListThreshold: largeListThreshold,
          largeListMenuMaxHeight: largeListMenuMaxHeight,
        ),
      ],
    );
  }
}

class _SearchableMultiChoiceFilter<T> extends StatefulWidget {
  const _SearchableMultiChoiceFilter({
    required this.options,
    required this.selectedValues,
    required this.onToggle,
    required this.spacing,
    required this.menuMaxHeight,
  });

  final List<FilterOption<T>> options;
  final Set<T> selectedValues;
  final ValueChanged<T> onToggle;
  final double spacing;
  final double menuMaxHeight;

  @override
  State<_SearchableMultiChoiceFilter<T>> createState() =>
      _SearchableMultiChoiceFilterState<T>();
}

class _SearchableMultiChoiceFilterState<T>
    extends State<_SearchableMultiChoiceFilter<T>> {
  final _fieldKey = GlobalKey();
  final _layerLink = LayerLink();
  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
    _textController.addListener(_handleQueryChanged);
  }

  @override
  void dispose() {
    _closeMenu();
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    _textController
      ..removeListener(_handleQueryChanged)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus) {
      _openMenu();
      return;
    }

    _closeMenu();
    _textController.clear();
    setState(() {});
  }

  void _handleQueryChanged() {
    if (_focusNode.hasFocus) {
      _openMenu();
    }
    _overlayEntry?.markNeedsBuild();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant _SearchableMultiChoiceFilter<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _overlayEntry?.markNeedsBuild();
      }
    });
  }

  void _openMenu() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }

    _overlayEntry = OverlayEntry(builder: _buildMenuOverlay);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeMenu() {
    _overlayEntry
      ?..remove()
      ..dispose();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedOptions = _selectedOptions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: TextFieldTapRegion(
            child: TextField(
              key: _fieldKey,
              controller: _textController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: 'Search options',
                isDense: true,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                _openMenu();
              },
              onTapOutside: (_) {
                _focusNode.unfocus();
              },
              onEditingComplete: () {
                _focusNode.unfocus();
              },
            ),
          ),
        ),
        if (!_focusNode.hasFocus && selectedOptions.isNotEmpty) ...[
          const SizedBox(height: 8),
          _SelectedOptionChips<T>(
            options: selectedOptions,
            selectedValues: widget.selectedValues,
            onToggle: widget.onToggle,
            spacing: widget.spacing,
            showUnselected: false,
          ),
        ],
      ],
    );
  }

  Widget _buildMenuOverlay(BuildContext context) {
    final fieldBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (fieldBox == null || !fieldBox.hasSize) {
      return const SizedBox.shrink();
    }

    final fieldSize = fieldBox.size;
    final fieldOffset = fieldBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.sizeOf(context);
    final availableHeight =
        screenSize.height - fieldOffset.dy - fieldSize.height - 16;
    final usableHeight = availableHeight <= 0
        ? widget.menuMaxHeight
        : availableHeight;
    final menuMaxHeight = usableHeight < 120
        ? usableHeight
        : widget.menuMaxHeight.clamp(120.0, usableHeight).toDouble();
    final filteredOptions = _filteredOptions;

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 6),
          child: Align(
            alignment: Alignment.topLeft,
            child: TextFieldTapRegion(
              child: Material(
                elevation: 6,
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: fieldSize.width,
                    maxWidth: fieldSize.width,
                    maxHeight: menuMaxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: filteredOptions.isEmpty
                        ? const _EmptyOptionMenuRow()
                        : Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: ListView.builder(
                              controller: _scrollController,
                              primary: false,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: filteredOptions.length,
                              itemBuilder: (context, index) {
                                final option = filteredOptions[index];
                                final selected = widget.selectedValues.contains(
                                  option.value,
                                );
                                return _OptionMenuRow<T>(
                                  option: option,
                                  selected: selected,
                                  onToggle: () {
                                    widget.onToggle(option.value);
                                    _focusNode.requestFocus();
                                    _overlayEntry?.markNeedsBuild();
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<FilterOption<T>> get _filteredOptions {
    final query = _textController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.options;
    }

    return [
      for (final option in widget.options)
        if (option.label.toLowerCase().contains(query)) option,
    ];
  }

  List<FilterOption<T>> get _selectedOptions {
    return [
      for (final option in widget.options)
        if (widget.selectedValues.contains(option.value)) option,
    ];
  }
}

class _OptionMenuRow<T> extends StatelessWidget {
  const _OptionMenuRow({
    required this.option,
    required this.selected,
    required this.onToggle,
  });

  final FilterOption<T> option;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  option.label,
                  style: textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyOptionMenuRow extends StatelessWidget {
  const _EmptyOptionMenuRow();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.search_off_rounded, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Text(
            'No matches',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _SelectedOptionChips<T> extends StatelessWidget {
  const _SelectedOptionChips({
    required this.options,
    required this.selectedValues,
    required this.onToggle,
    required this.spacing,
    required this.showUnselected,
  });

  final List<FilterOption<T>> options;
  final Set<T> selectedValues;
  final ValueChanged<T> onToggle;
  final double spacing;
  final bool showUnselected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (final option in options)
          if (showUnselected || selectedValues.contains(option.value))
            FilterChip(
              label: Text(option.label),
              selected: selectedValues.contains(option.value),
              onSelected: (_) => onToggle(option.value),
            ),
      ],
    );
  }
}
