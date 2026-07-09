import 'package:flutter/material.dart';

import '../../../../shared/widgets/error_message_state.dart';

class SeasonalLoadingState extends StatelessWidget {
  const SeasonalLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class SeasonalEmptyState extends StatelessWidget {
  const SeasonalEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No upcoming anime found.'));
  }
}

class SeasonalErrorState extends StatelessWidget {
  const SeasonalErrorState({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return ErrorMessageState(
      title: 'Could not load upcoming anime',
      error: error,
    );
  }
}
