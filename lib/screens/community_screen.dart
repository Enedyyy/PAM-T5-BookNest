// "книги, доступные у других"
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../widgets/book_card.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    List<Book> books = [];
    for (var b in communityBooks) {
      if (b.status == BookStatus.available) {
        books.add(b);
      }
    }

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
              return BookCard(
                book: book,
                showStatus: false, // тут все книги свободны, штамп не нужен
                onTap: () => context.push('/books/${book.id}'),
                footer: Row(
                  children: [
                    Icon(Icons.person_outline, size: 18, color: s.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(people[book.ownerId]!, overflow: TextOverflow.ellipsis),
                    ),
                    FilledButton.tonal(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Запрос отправлен: ' + book.title)),
                        );
                      },
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
