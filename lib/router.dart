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
  initialLocation: '/login', // приложение стартует на экране входа
  routes: [
    GoRoute(
      path: '/login', // ВНЕ вкладок - вход показывается без нижнего меню
      builder: (context, state) => const LoginScreen(),
    ),

    // карточка книги и форма книги - свои отдельные маршруты, а не частьодной вкладки: открыть книгу можно с полки, у соседей и из обмено

    GoRoute(
      // '/books/new' идёт ПЕРЕД '/books/:id' - иначе 'new' поймает :id
      // и int.parse('new') упадёт
      path: '/books/new',
      builder: (context, state) => const BookFormScreen(),
    ),
    GoRoute(
      path: '/books/:id',
      builder: (context, state) {
        var idText = state.pathParameters['id']!; // в адресе всё строка, даже число
        var id = int.parse(idText);
        print('открываю книгу ' + idText); // проверял что id доходит, пусть будет
        return BookDetailsScreen(id: id);
      },
      routes: [
        GoRoute(
          path: 'edit', // полный адрес: /books/7/edit
          builder: (context, state) {
            // тоже самое что выше, только в одну строку
            return BookFormScreen(id: int.parse(state.pathParameters['id']!));
          },
        ),
      ],
    ),

    // постоянные вкладки снизу: NavigationBar остаётся на экране,
    // пока меняется только содержимое
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
