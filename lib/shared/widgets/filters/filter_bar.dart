import 'package:flutter/material.dart';

import '../../models/sort_direction.dart';
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
    this.sortDirection,
    this.onSortDirectionToggle,
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
  final SortDirection? sortDirection;
  final VoidCallback? onSortDirectionToggle;
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
            _SortControlGroup<T>(
              sortValue: sortValue,
              sortOptions: sortOptions,
              showLabel: expanded,
              height: height,
              onSortSelected: onSortSelected,
              sortDirection: sortDirection,
              onSortDirectionToggle: onSortDirectionToggle,
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

class _SortControlGroup<T> extends StatelessWidget {
  const _SortControlGroup({
    required this.sortValue,
    required this.sortOptions,
    required this.showLabel,
    required this.height,
    required this.onSortSelected,
    this.sortDirection,
    this.onSortDirectionToggle,
  });

  final T sortValue;
  final List<FilterSortOption<T>> sortOptions;
  final bool showLabel;
  final double height;
  final ValueChanged<T> onSortSelected;
  final SortDirection? sortDirection;
  final VoidCallback? onSortDirectionToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasDirection = sortDirection != null && onSortDirectionToggle != null;
    final outerRadius = BorderRadius.circular(showLabel ? 8 : height / 2);
    final sortRadius = hasDirection
        ? BorderRadius.horizontal(
            left: Radius.circular(showLabel ? 8 : height / 2),
          )
        : outerRadius;
    final directionRadius = BorderRadius.horizontal(
      right: Radius.circular(showLabel ? 8 : height / 2),
    );

    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: outerRadius,
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilterSortMenu<T>(
            value: sortValue,
            options: sortOptions,
            showLabel: showLabel,
            height: height,
            embedded: true,
            borderRadius: sortRadius,
            onSelected: onSortSelected,
          ),
          if (hasDirection) ...[
            SizedBox(
              height: height * 0.54,
              child: VerticalDivider(
                width: 1,
                thickness: 1,
                color: colorScheme.outlineVariant,
              ),
            ),
            _SortDirectionButton(
              direction: sortDirection!,
              height: height,
              borderRadius: directionRadius,
              onPressed: onSortDirectionToggle!,
            ),
          ],
        ],
      ),
    );
  }
}

class _SortDirectionButton extends StatelessWidget {
  const _SortDirectionButton({
    required this.direction,
    required this.height,
    required this.borderRadius,
    required this.onPressed,
  });

  final SortDirection direction;
  final double height;
  final BorderRadius borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDescending = direction.isDescending;

    return Tooltip(
      message: isDescending ? 'Descending' : 'Ascending',
      child: SizedBox(
        height: height,
        width: height,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onPressed,
          child: Icon(
            isDescending ? Icons.south_rounded : Icons.north_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
      ),
    );
  }
}
