import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/browse/presentation/browse_page.dart';
import '../features/my_list/presentation/my_list_page.dart';
import '../features/seasonal/presentation/seasonal_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../shared/widgets/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.myList.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.myList.path,
            name: AppRoute.myList.name,
            pageBuilder: (context, state) {
              return const NoTransitionPage<void>(child: MyListPage());
            },
          ),
          GoRoute(
            path: AppRoute.seasonal.path,
            name: AppRoute.seasonal.name,
            pageBuilder: (context, state) {
              return const NoTransitionPage<void>(child: SeasonalPage());
            },
          ),
          GoRoute(
            path: AppRoute.browse.path,
            name: AppRoute.browse.name,
            pageBuilder: (context, state) {
              return const NoTransitionPage<void>(child: BrowsePage());
            },
          ),
          GoRoute(
            path: AppRoute.settings.path,
            name: AppRoute.settings.name,
            pageBuilder: (context, state) {
              return const NoTransitionPage<void>(child: SettingsPage());
            },
          ),
        ],
      ),
    ],
  );
});

enum AppRoute {
  myList('/my-list', 'my-list', 'My list'),
  seasonal('/seasonal', 'seasonal', 'Seasonal'),
  browse('/browse', 'browse', 'Browse'),
  settings('/settings', 'settings', 'Settings');

  const AppRoute(this.path, this.name, this.label);

  final String path;
  final String name;
  final String label;
}
