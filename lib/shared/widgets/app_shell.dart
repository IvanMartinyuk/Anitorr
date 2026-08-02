import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../services/navigation_history.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.location,
    required this.navigationHistory,
    required this.child,
    super.key,
  });

  final String location;
  final NavigationHistory navigationHistory;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) => _handlePointerDown(context, event),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useSidebar = constraints.maxWidth >= 720;
          final selectedRoute = _selectedNavigationRoute(context, location);

          if (useSidebar) {
            return Scaffold(
              body: Row(
                children: [
                  _SidebarNavigation(
                    selectedRoute: selectedRoute,
                    navigationHistory: navigationHistory,
                  ),
                  Expanded(child: child),
                ],
              ),
            );
          }

          return Scaffold(
            body: child,
            bottomNavigationBar: _BottomNavigation(
              selectedRoute: selectedRoute,
              navigationHistory: navigationHistory,
            ),
          );
        },
      ),
    );
  }

  void _handlePointerDown(BuildContext context, PointerDownEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }

    if (event.buttons & kBackMouseButton != 0) {
      final destination = navigationHistory.back();
      if (destination != null) {
        context.go(destination.location, extra: destination.extra);
      } else if (context.canPop()) {
        context.pop();
      }
      return;
    }

    if (event.buttons & kForwardMouseButton != 0) {
      final destination = navigationHistory.forward();
      if (destination != null) {
        context.go(destination.location, extra: destination.extra);
      }
    }
  }
}

class _SidebarNavigation extends StatelessWidget {
  const _SidebarNavigation({
    required this.selectedRoute,
    required this.navigationHistory,
  });

  final AppRoute selectedRoute;
  final NavigationHistory navigationHistory;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surfaceContainer),
      child: SizedBox(
        width: 240,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Center(
                    child: Image.asset(
                      'docs/design/assets/images/logo.png',
                      width: 160,
                      height: 160,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      for (final item in _navigationItems)
                        _SidebarDestination(
                          item: item,
                          selected: item.route == selectedRoute,
                          navigationHistory: navigationHistory,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarDestination extends StatelessWidget {
  const _SidebarDestination({
    required this.item,
    required this.selected,
    required this.navigationHistory,
  });

  final _NavigationItem item;
  final bool selected;
  final NavigationHistory navigationHistory;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        animationDuration: const Duration(milliseconds: 160),
        child: ListTile(
          selected: selected,
          selectedColor: colorScheme.primary,
          iconColor: colorScheme.onSurfaceVariant,
          textColor: colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leading: Icon(item.icon),
          title: Text(item.route.label),
          onTap: () {
            navigationHistory.push(location: item.route.path);
            context.go(item.route.path);
          },
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.selectedRoute,
    required this.navigationHistory,
  });

  final AppRoute selectedRoute;
  final NavigationHistory navigationHistory;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _navigationItems.indexWhere(
      (item) => item.route == selectedRoute,
    );

    return NavigationBar(
      selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
      onDestinationSelected: (index) {
        final location = _navigationItems[index].route.path;
        navigationHistory.push(location: location);
        context.go(location);
      },
      destinations: [
        for (final item in _navigationItems)
          NavigationDestination(icon: Icon(item.icon), label: item.route.label),
      ],
    );
  }
}

class _NavigationItem {
  const _NavigationItem({required this.route, required this.icon});

  final AppRoute route;
  final IconData icon;
}

const _navigationItems = [
  _NavigationItem(route: AppRoute.myList, icon: Icons.playlist_play_outlined),
  _NavigationItem(
    route: AppRoute.seasonal,
    icon: Icons.calendar_month_outlined,
  ),
  _NavigationItem(route: AppRoute.browse, icon: Icons.explore_outlined),
  _NavigationItem(route: AppRoute.settings, icon: Icons.settings_outlined),
];

AppRoute _selectedNavigationRoute(BuildContext context, String location) {
  if (location.startsWith('/anime/')) {
    final extra = GoRouterState.of(context).extra;
    if (extra is AnimeDetailsRouteExtra) {
      return extra.sourceRoute;
    }
    return AppRoute.browse;
  }

  for (final item in _navigationItems) {
    if (item.route.path == location) {
      return item.route;
    }
  }

  return AppRoute.myList;
}
