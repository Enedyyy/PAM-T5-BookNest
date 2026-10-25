// router.dart - карта всего приложения: какой адрес открывает какой экран.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_screen.dart';
import 'screens/library_screen.dart';
import 'screens/community_screen.dart';
import 'screens/loans_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/book_details_screen.dart';
import 'screens/book_form_screen.dart';
import 'widgets/app_shell.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/books/new',
      builder: (context, state) => const BookFormScreen(),
    ),

    GoRoute(
      path: '/books/:id',
      builder: (context, state) {
        var idText = state.pathParameters['id']!;
        var id = int.parse(idText);
        print('открываю книгу ' + idText);
        return BookDetailsScreen(id: id);
      },
      routes: [

        GoRoute(
          path: 'edit',
          builder: (context, state) {
            return BookFormScreen(id: int.parse(state.pathParameters['id']!));
          },
        ),
      ],
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/library', builder: (context, state) => const LibraryScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/community', builder: (context, state) => const CommunityScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/loans', builder: (context, state) => const LoansScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        ]),
      ],
    ),
  ],
);
