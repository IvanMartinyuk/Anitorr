import 'package:flutter/material.dart';

abstract class FilterLayoutModule {
  const FilterLayoutModule();

  Widget build(BuildContext context);
}

final class FilterRowModule extends FilterLayoutModule {
  const FilterRowModule({
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}

final class FilterWidgetModule extends FilterLayoutModule {
  const FilterWidgetModule(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class FilterLayout extends StatelessWidget {
  const FilterLayout({
    required this.modules,
    this.moduleSpacing = 18,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });

  final List<FilterLayoutModule> modules;
  final double moduleSpacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (index, module) in modules.indexed) ...[
              if (index > 0) SizedBox(height: moduleSpacing),
              module.build(context),
            ],
          ],
        ),
      ),
    );
  }
}
