// профиль
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Нет'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Да, выйти'),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    int lentNow = 0;
    int borrowedNow = 0;
    for (var l in loans) {
      if (l.status == 'returned') continue; // возвращённые не считаем
      if (iLent(l)) {
        lentNow++;
      } else {
        borrowedNow = borrowedNow + 1;
      }
    }

    Widget stat(String value, String label) => Expanded(
          child: Column(children: [
            Text(value, style: t.headlineMedium),
            Text(label),
          ]),
        );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: Text('Профиль', style: t.headlineMedium)),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Выйти',
              onPressed: () => _logout(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(people[currentUserId]!, style: t.titleLarge),
                  const Text('CR-232'),
                  Text('eduard@booknest.app', style: TextStyle(color: s.onSurfaceVariant)),
                ],
              ),
            ),
            CircleAvatar(
              radius: 36,
              backgroundColor: s.tertiaryContainer,
              child: Text('ЭБ', style: t.headlineSmall?.copyWith(color: s.onTertiaryContainer)),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            stat('${myBooks.length}', 'книг'),
            stat('$lentNow', 'выдано'),
            stat('$borrowedNow', 'взято'),
          ],
        ),
      ],
    );
  }
}
