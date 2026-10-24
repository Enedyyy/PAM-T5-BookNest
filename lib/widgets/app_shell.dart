// главный каркас с меню сверху

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/loans_model.dart';
import 'paper_background.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme; // цвета из темы

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // меню сверху
            NavigationBar(
              backgroundColor: s.surfaceContainerLow,
              indicatorColor: s.primaryContainer,
              selectedIndex: navigationShell.currentIndex,
              // goBranch переключает вкладку и помнит её собственный стек/прокрутку
              onDestinationSelected: (index) {
                navigationShell.goBranch(index);
              },
              destinations: [
                const NavigationDestination(icon: Icon(Icons.auto_stories_outlined), label: 'Полка'),
                const NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Соседи'),
                NavigationDestination(
                  // запросил книгу где угодно - число тут растёт само
                  icon: Consumer<LoansModel>(
                    builder: (context, loans, child) => Badge(
                      backgroundColor: s.primary,
                      textColor: s.onPrimary,
                      label: Text('${loans.activeCount}'),
                      isLabelVisible: loans.activeCount > 0,
                      child: child!,
                    ),
                    child: const Icon(Icons.swap_horiz),
                  ),
                  label: 'Обмены',
                ),
                const NavigationDestination(icon: Icon(Icons.person_outline), label: 'Я'),
              ],
            ),
            Expanded(child: PaperBackground(child: navigationShell)),
          ],
        ),
      ),
    );
  }
}