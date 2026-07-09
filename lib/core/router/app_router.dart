import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_names.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/results/presentation/screens/results_screen.dart';
import '../../features/route_detail/presentation/screens/route_detail_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            name: RouteNames.homeName,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.favorites,
            name: RouteNames.favoritesName,
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: RouteNames.history,
            name: RouteNames.historyName,
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: RouteNames.settings,
            name: RouteNames.settingsName,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.search,
        name: RouteNames.searchName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SearchScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: RouteNames.results,
        name: RouteNames.resultsName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ResultsScreen(
            originLat: extra?['originLat'] as double? ?? 7.1198,
            originLng: extra?['originLng'] as double? ?? -73.1227,
            destinationLat: extra?['destinationLat'] as double? ?? 7.1300,
            destinationLng: extra?['destinationLng'] as double? ?? -73.1100,
            originName: extra?['originName'] as String? ?? 'Mi ubicación',
            destinationName: extra?['destinationName'] as String? ?? 'Destino',
          );
        },
      ),
      GoRoute(
        path: '${RouteNames.routeDetail}/:id',
        name: RouteNames.routeDetailName,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: RouteDetailScreen(
              routeId: id,
              searchExtra: extra,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
    ],
  );
});

/// Shell con NavigationBar persistente para las 4 pestañas principales
class _MainShell extends StatelessWidget {
  final Widget child;
  const _MainShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _BottomNav extends StatelessWidget {
  static final _tabs = [
    (path: RouteNames.home, icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Inicio'),
    (path: RouteNames.favorites, icon: Icons.bookmark_outline, activeIcon: Icons.bookmark, label: 'Favoritos'),
    (path: RouteNames.history, icon: Icons.history_outlined, activeIcon: Icons.history, label: 'Historial'),
    (path: RouteNames.settings, icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Ajustes'),
  ];

  int _locationIndex(String location) {
    if (location.startsWith(RouteNames.favorites)) return 1;
    if (location.startsWith(RouteNames.history)) return 2;
    if (location.startsWith(RouteNames.settings)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final current = _locationIndex(location);

    return NavigationBar(
      selectedIndex: current,
      onDestinationSelected: (i) {
        if (i != current) context.go(_tabs[i].path);
      },
      destinations: _tabs
          .map((t) => NavigationDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.activeIcon),
                label: t.label,
              ))
          .toList(),
    );
  }
}
