// "библиотека"
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../widgets/book_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 12, 8),
          child: Row(
            children: [
              Expanded(child: Text('Моя полка', style: t.headlineMedium)),
              IconButton.filled(
                icon: const Icon(Icons.add),
                tooltip: 'Добавить книгу',
                onPressed: () => context.push('/books/new'),
              ),
            ],
          ),
        ),
        // поле поиска
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Название или автор',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // ряд жанров
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: genres.length,
            separatorBuilder: (context, i) => const SizedBox(width: 8),
            itemBuilder: (context, i) => ChoiceChip(
              label: Text(genres[i]),
              selected: i == 0,
              onSelected: (_) {}, // не работает пока
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: myBooks.length,
            separatorBuilder: (context, i) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final book = myBooks[i];
              return BookCard(
                book: book,
                onTap: () {
                  context.push('/books/' + book.id.toString());
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
