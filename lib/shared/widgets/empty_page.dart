import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(title, style: textTheme.headlineMedium),
        ),
      ),
    );
  }
}
