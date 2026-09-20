// "книги, доступные у других"
// список чужих свободных книг, у каждой владелец и кнопка "Запросить"
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    // беру только свободные книги
    final books = communityBooks.where((b) => b.status == BookStatus.available).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('У соседей по полке', style: t.headlineMedium),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: books.length,
            separatorBuilder: (context, i) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final book = books[i];
              // тот же BookCard, что и на полке, только с footer
              return BookCard(
                book: book,
                showStatus: false, // тут все книги свободны, штамп не нужен
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
                ),
                // внизу: чья книга слева, кнопка справа
                footer: Row(
                  children: [
                    Icon(Icons.person_outline, size: 18, color: s.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(people[book.ownerId]!, overflow: TextOverflow.ellipsis),
                    ),
                    FilledButton.tonal(
                      onPressed: () {}, // нэма пока запроса
                      child: const Text('Запросить'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
