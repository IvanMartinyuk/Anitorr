import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/anime_details/presentation/anime_details_page.dart';
import '../features/browse/presentation/browse_page.dart';
import '../features/my_list/presentation/my_list_page.dart';
import '../features/seasonal/presentation/seasonal_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../shared/models/app_anime.dart';
import '../shared/services/navigation_history.dart';
import '../shared/widgets/app_shell.dart';
import '../shared/widgets/empty_page.dart';

final navigationHistoryProvider = Provider<NavigationHistory>((ref) {
  return NavigationHistory();
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final navigationHistory = ref.watch(navigationHistoryProvider);

  return GoRouter(
    initialLocation: AppRoute.myList.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final location = state.uri.toString();
          navigationHistory.sync(location: location, extra: state.extra);
          return AppShell(
            location: state.uri.path,
            navigationHistory: navigationHistory,
            child: child,
          );
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
            path: AppRoute.animeDetails.path,
            name: AppRoute.animeDetails.name,
            pageBuilder: (context, state) {
              final animeId = int.tryParse(
                state.pathParameters['animeId'] ?? '',
              );

              if (animeId == null) {
                return const NoTransitionPage<void>(
                  child: EmptyPage(title: 'Anime not found'),
                );
              }

              final extra = state.extra;
              final initialAnime = switch (extra) {
                AnimeDetailsRouteExtra(:final anime) => anime,
                AppAnime anime => anime,
                _ => null,
              };
              final sourceRoute = switch (extra) {
                AnimeDetailsRouteExtra(:final sourceRoute) => sourceRoute,
                _ => null,
              };

              return NoTransitionPage<void>(
                child: AnimeDetailsPage(
                  animeId: animeId,
                  initialAnime: initialAnime,
                  sourceRoute: sourceRoute,
                ),
              );
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
  animeDetails('/anime/:animeId', 'anime-details', 'Anime details'),
  browse('/browse', 'browse', 'Browse'),
  settings('/settings', 'settings', 'Settings');

  const AppRoute(this.path, this.name, this.label);

  final String path;
  final String name;
  final String label;
}

final class AnimeDetailsRouteExtra {
  const AnimeDetailsRouteExtra({
    required this.anime,
    required this.sourceRoute,
  });

  final AppAnime anime;
  final AppRoute sourceRoute;
}
