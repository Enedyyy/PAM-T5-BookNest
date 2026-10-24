// "книги, доступные у других"
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/book.dart';
import '../models/books_model.dart';
import '../models/loans_model.dart';
import '../widgets/book_card.dart';
import '../widgets/error_view.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  Future<void> _request(BuildContext context, Book book) async {
    final error = await context.read<LoansModel>().request(book);
    if (!context.mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    final error2 = await context.read<BooksModel>().update(book.copyWith(status: BookStatus.lent));
    if (!context.mounted) return;
    String text = 'Запрос отправлен: ' + book.title;
    if (error2 != null) text = error2;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final model = context.watch<BooksModel>();

    Widget body;
    if (model.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (model.error != null) {
      body = ErrorView(message: model.error!, onRetry: () => context.read<BooksModel>().load());
    } else {
      final books = model.community;
      body = RefreshIndicator(
        color: s.primary,
        onRefresh: () => context.read<BooksModel>().refresh(),
        child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: books.length,
        separatorBuilder: (_, i) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final book = books[i];
          return BookCard(
            book: book,
            showStatus: false,
            onTap: () => context.push('/books/${book.id}'),
            footer: Row(
              children: [
                Icon(Icons.person_outline, size: 18, color: s.primary),
                const SizedBox(width: 4),
                Expanded(child: Text(book.ownerName, overflow: TextOverflow.ellipsis)),
                FilledButton.tonal(
                  onPressed: () => _request(context, book),
                  child: const Text('Запросить'),
                ),
              ],
            ),
          );
        },
      ),
      );
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
          child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: body),
        ),
      ],
    );
  }
}
