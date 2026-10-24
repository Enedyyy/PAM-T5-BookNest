// статус книги - доступна / выдана
import 'package:flutter/material.dart';
import '../data/book.dart';

class StatusBadge extends StatelessWidget {
  final BookStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final free = status == BookStatus.available; // свободна или нет
    final s = Theme.of(context).colorScheme;
    final color = free ? s.primary : s.tertiary; // цвет из темы

    return Transform.rotate(
      angle: -0.05, // наклон
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2), // рамка штампа
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          free ? 'ДОСТУПНА' : 'ВЫДАНА',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color),
        ),
      ),
    );
  }
}
