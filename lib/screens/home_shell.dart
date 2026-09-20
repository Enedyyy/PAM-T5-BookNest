// главный каркас с меню
import 'package:flutter/material.dart';
import 'library_screen.dart';
import 'community_screen.dart';
import 'loans_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0; // какая вкладка открыта сейчас

  // сами экраны остаются Stateless
  final _pages = const [
    LibraryScreen(),
    CommunityScreen(),
    LoansScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea - чтобы меню не залезало под статус-бар
      body: SafeArea(
        child: Column(
          children: [
            // меню сверху
            NavigationBar(
              selectedIndex: _index,
              // при нажатии меняем только номер вкладки
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.auto_stories_outlined), label: 'Полка'),
                NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Соседи'),
                NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Обмены'),
                NavigationDestination(icon: Icon(Icons.person_outline), label: 'Я'),
              ],
            ),
            // остальное место занимает выбранный экран
            Expanded(child: _pages[_index]),
          ],
        ),
      ),
    );
  }
}
