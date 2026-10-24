// "библиотека" - моя полка
// данные берёт у BooksModel, а не из стартового списка
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/book.dart';
import '../models/books_model.dart';
import '../widgets/book_card.dart';
import '../widgets/error_view.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final model = context.watch<BooksModel>();

    Widget body;
    if (model.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (model.error != null) {
      body = ErrorView(
        message: model.error!,
        onRetry: () => context.read<BooksModel>().load(),
      );
    } else {
      final books = model.myShelf;
      if (books.isEmpty) {
        body = const Center(child: Text('Ничего не нашлось'));
      } else {
        body = RefreshIndicator(
          color: s.primary,
          onRefresh: () => context.read<BooksModel>().refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: books.length,
            separatorBuilder: (context, i) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final book = books[i];
              return BookCard(
                book: book,
                onTap: () {
                  context.push('/books/' + book.id.toString());
                },
              );
            },
          ),
        );
      }
    }

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (v) => context.read<BooksModel>().setQuery(v),
            decoration: const InputDecoration(
              hintText: 'Название или автор',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: genres.length,
            separatorBuilder: (context, i) => const SizedBox(width: 8),
            itemBuilder: (context, i) => ChoiceChip(
              label: Text(genres[i]),
              selected: model.genre == genres[i],
              onSelected: (_) => context.read<BooksModel>().setGenre(genres[i]),
            ),
          ),
        ),

        Expanded(
          child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: body),
        ),
      ],
    );
  }
}
