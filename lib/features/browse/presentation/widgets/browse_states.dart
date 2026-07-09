import 'package:flutter/material.dart';

import '../../../../shared/widgets/error_message_state.dart';

class BrowseLoadingState extends StatelessWidget {
  const BrowseLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class BrowseEmptyState extends StatelessWidget {
  const BrowseEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No anime found.'));
  }
}

class BrowseErrorState extends StatelessWidget {
  const BrowseErrorState({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return ErrorMessageState(title: 'Could not load anime', error: error);
  }
}
