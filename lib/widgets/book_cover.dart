// "обложка": картинок нет
import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class BookCover extends StatelessWidget {
  final Book book;
  final double width; // высоту считаю от ширины, так можно делать маленькую и большую

  const BookCover({super.key, required this.book, this.width = 60});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;

    final bg = [s.primary, s.tertiary, s.secondary];
    final fg = [s.onPrimary, s.onTertiary, s.onSecondary];
    final i = book.id % 3; // по id выбираю цвет, у одной книги он всегда один

    return Container(
      width: width,
      height: width * 1.4,
      decoration: BoxDecoration(
        color: bg[i],
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(8),
          right: Radius.circular(2),
        ),
      ),
      child: Row(
        children: [
          // буква по центру, Expanded забирает всё место кроме полоски
          Expanded(
            child: Center(
              child: Text(
                book.title.substring(0, 1), // первая буква названия
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: width * 0.4, color: fg[i]),
              ),
            ),
          ),
          // тёмная полоска корешка справа
          Container(width: width * 0.1, color: fg[i].withValues(alpha: 0.25)),
        ],
      ),
    );
  }
}
