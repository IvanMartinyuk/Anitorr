import 'package:flutter/material.dart';

class FilterSearchSurface extends StatelessWidget {
  const FilterSearchSurface({
    required this.expanded,
    required this.height,
    required this.child,
    super.key,
  });

  final bool expanded;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(expanded ? 8 : height / 2),
      ),
      child: SizedBox(
        height: height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: expanded ? 0 : 4),
          child: child,
        ),
      ),
    );
  }
}
