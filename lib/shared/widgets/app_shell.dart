import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useSidebar = constraints.maxWidth >= 720;

        if (useSidebar) {
          return Scaffold(
            body: Row(
              children: [
                _SidebarNavigation(location: location),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: _BottomNavigation(location: location),
        );
      },
    );
  }
}

class _SidebarNavigation extends StatelessWidget {
  const _SidebarNavigation({required this.location});

  final String location;

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
                          selected: _isRouteSelected(item.route, location),
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
  const _SidebarDestination({required this.item, required this.selected});

  final _NavigationItem item;
  final bool selected;

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
          onTap: () => context.go(item.route.path),
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _navigationItems.indexWhere(
      (item) => _isRouteSelected(item.route, location),
    );

    return NavigationBar(
      selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
      onDestinationSelected: (index) {
        context.go(_navigationItems[index].route.path);
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

bool _isRouteSelected(AppRoute route, String location) {
  if (route.path == location) {
    return true;
  }

  return route == AppRoute.seasonal && location.startsWith('/anime/');
}
