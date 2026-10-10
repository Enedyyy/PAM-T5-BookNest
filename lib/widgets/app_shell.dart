// главный каркас с меню сверху

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'paper_background.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // меню сверху
            NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              // goBranch переключает вкладку и помнит её собственный стек/прокрутку
              onDestinationSelected: (index) {
                navigationShell.goBranch(index);
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.auto_stories_outlined), label: 'Полка'),
                NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Соседи'),
                NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Обмены'),
                NavigationDestination(icon: Icon(Icons.person_outline), label: 'Я'),
              ],
            ),
            Expanded(child: PaperBackground(child: navigationShell)),
          ],
        ),
      ),
    );
  }
}
