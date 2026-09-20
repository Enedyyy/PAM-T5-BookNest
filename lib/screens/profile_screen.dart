// профиль
// аватар с инициалами, имя, e-mail, статистика, выход
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    // статистика считается из данных: считаю только не возвращённые обмены
    final lentNow = loans.where((l) => iLent(l) && l.status != 'returned').length;
    final borrowedNow = loans.where((l) => !iLent(l) && l.status != 'returned').length;

    // Expanded, чтобы три цифры делили ширину поровну
    Widget stat(String value, String label) => Expanded(
          child: Column(children: [
            Text(value, style: t.headlineMedium),
            Text(label),
          ]),
        );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // заголовок слева, кнопка выхода справа
        Row(
          children: [
            Expanded(child: Text('Профиль', style: t.headlineMedium)),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Выйти',
              // уходим на вход и стираем историю экранов, чтобы назад не вернул
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // имя слева, аватар справа
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(people[currentUserId]!, style: t.titleLarge),
                  const Text('CR-233'),
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
        // три цифры в ряд
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
