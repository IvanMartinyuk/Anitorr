import 'package:flutter/material.dart';

import 'filter_search_surface.dart';
import 'filter_sort_menu.dart';
import 'filter_toggle_button.dart';
import 'text_search_filter.dart';

class FilterBar<T> extends StatelessWidget {
  const FilterBar({
    required this.expanded,
    required this.searchLabel,
    required this.searchValue,
    required this.onSearchChanged,
    required this.sortValue,
    required this.sortOptions,
    required this.onSortSelected,
    required this.activeFilterCount,
    required this.onToggleFilters,
    this.searchHintText,
    this.height = 48,
    super.key,
  });

  final bool expanded;
  final String searchLabel;
  final String searchValue;
  final String? searchHintText;
  final ValueChanged<String> onSearchChanged;
  final T sortValue;
  final List<FilterSortOption<T>> sortOptions;
  final ValueChanged<T> onSortSelected;
  final int activeFilterCount;
  final VoidCallback onToggleFilters;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final search = FilterSearchSurface(
          expanded: expanded,
          height: height,
          child: TextSearchFilter(
            label: searchLabel,
            value: searchValue,
            hintText: searchHintText,
            borderless: !expanded,
            width: double.infinity,
            onChanged: onSearchChanged,
          ),
        );
        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilterSortMenu<T>(
              value: sortValue,
              options: sortOptions,
              showLabel: expanded,
              height: height,
              onSelected: onSortSelected,
            ),
            const SizedBox(width: 8),
            FilterToggleButton(
              count: activeFilterCount,
              height: height,
              onPressed: onToggleFilters,
            ),
          ],
        );

        if (constraints.maxWidth < 620) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              search,
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerRight, child: actions),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: search),
            const SizedBox(width: 12),
            actions,
          ],
        );
      },
    );
  }
}
