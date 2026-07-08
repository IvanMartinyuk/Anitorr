import 'package:flutter/material.dart';

class PaginationButton extends StatelessWidget {
  const PaginationButton({
    required this.child,
    this.onPressed,
    this.selected = false,
    this.tooltip,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool selected;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    final foregroundColor = selected
        ? colorScheme.onPrimaryContainer
        : enabled
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha: 0.38);

    final button = SizedBox.square(
      dimension: 40,
      child: Material(
        color: selected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: IconTheme(
              data: IconThemeData(color: foregroundColor),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: foregroundColor),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip == null) {
      return button;
    }

    return Tooltip(message: tooltip!, child: button);
  }
}
