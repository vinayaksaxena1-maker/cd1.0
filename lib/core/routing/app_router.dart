import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/navigation/main_shell.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/cards/cards_screen.dart';
import '../../presentation/screens/reminders/reminders_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/scan/scan_screen.dart';
import '../../presentation/screens/categories/categories_screen.dart';
import '../../presentation/screens/digital_card/digital_card_screen.dart';
import '../../presentation/screens/scan/review_scan_screen.dart';
import '../../presentation/screens/cards/card_detail_screen.dart';
import '../../presentation/screens/cards/card_edit_screen.dart';
import '../../presentation/screens/profile/user_profile_edit_screen.dart';
import '../../data/models/extracted_card_data.dart';

/// Declarative Routing Configuration for CardSaathi using go_router
abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      // Stateful Nested Shell for Bottom Navigation Tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 1: Cards & Contacts
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cards',
                builder: (context, state) {
                  final catId = state.uri.queryParameters['category'];
                  return CardsScreen(initialCategoryId: catId);
                },
              ),
            ],
          ),
          // Branch 2: Reminders & Meetings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reminders',
                builder: (context, state) => const RemindersScreen(),
              ),
            ],
          ),
          // Branch 3: Profile & Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Full-Screen Push Routes (Overlaying Navigation Shell)
      GoRoute(
        path: '/scan',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
        path: '/review-scan',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final data = state.extra as ExtractedCardData?;
          return ReviewScanScreen(initialData: data);
        },
      ),
      GoRoute(
        path: '/categories',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/digital-card',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DigitalCardScreen(),
      ),
      GoRoute(
        path: '/cards/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CardDetailScreen(cardId: id);
        },
      ),
      GoRoute(
        path: '/cards/:id/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CardEditScreen(cardId: id);
        },
      ),
      GoRoute(
        path: '/profile/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const UserProfileEditScreen(),
      ),
    ],
  );
}
