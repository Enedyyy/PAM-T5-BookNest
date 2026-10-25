//  карточка книги
// по-прежнему получает только id из адреса, но ищет книгу через модель
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/book.dart';
import '../data/dates.dart';
import '../data/session.dart';
import '../models/books_model.dart';
import '../models/loans_model.dart';
import '../widgets/book_cover.dart';
import '../widgets/error_view.dart';
import '../widgets/status_badge.dart';
import '../widgets/paper_background.dart';

class BookDetailsScreen extends StatelessWidget {
  final int id;
  const BookDetailsScreen({super.key, required this.id});

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

  // удаление своей книги: сначала спрашиваю, потом удаляю через модель
  Future<void> _delete(BuildContext context, Book book) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Удалить книгу?'),
        content: Text(book.title),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text('Нет')),
          FilledButton(onPressed: () => Navigator.pop(dialogCtx, true), child: const Text('Удалить')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final error = await context.read<BooksModel>().remove(book.id);
    if (!context.mounted) return; // экран мог закрыться пока ждали
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Удалено: ' + book.title)));
    context.pop(); // книги больше нет - её экран тоже уходит
  }

  @override
  Widget build(BuildContext context) {
    final books = context.watch<BooksModel>();
    final loans = context.watch<LoansModel>();
    final book = books.byId(id);

    // книги нет в списке: или список ещё грузится, или ошибка, или такой книги нет
    if (book == null) {
      Widget body;
      if (books.isLoading) {
        body = const Center(child: CircularProgressIndicator());
      } else if (books.error != null) {
        body = ErrorView(message: books.error!, onRetry: () => context.read<BooksModel>().load());
      } else {
        body = const Center(child: Text('Книга не найдена'));
      }
      return Scaffold(appBar: AppBar(title: const Text('О книге')), body: body);
    }

    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final mine = book.ownerId == currentUserId; // моя книга или чужая
    bool free = false;
    if (book.status == BookStatus.available) free = true;
    final loan = loans.activeLoanOf(book.id);

    String ownerName;
    if (mine) {
      ownerName = 'Я';
    } else {
      ownerName = book.ownerName;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('О книге')),
      body: PaperBackground(child: ListView(
        children: [
          Container(
            color: s.primaryContainer,
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title, style: t.headlineSmall),
                      const SizedBox(height: 8),
                      Text(book.author, style: t.titleMedium?.copyWith(fontStyle: FontStyle.italic)),
                      const SizedBox(height: 14),
                      StatusBadge(status: book.status),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                BookCover(book: book, width: 110), // большая обложка
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(book.genre),
            subtitle: const Text('Жанр'),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(ownerName),
            subtitle: const Text('Владелец'),
          ),
          if (loan != null)
            ListTile(
              leading: const Icon(Icons.event_outlined),
              title: Text(shortDate(loan.dueDate)),
              subtitle: const Text('Вернуть до'),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: mine
                ? Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('/books/${book.id}/edit'),
                          child: const Text('Редактировать'),
                        ),
                      ),
                      if (free) ...[
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () => _delete(context, book),
                          child: Text('Удалить', style: TextStyle(color: s.error)),
                        ),
                      ],
                    ],
                  )
                : FilledButton(
                    onPressed: free ? () => _request(context, book) : null, // null = кнопка серая
                    child: Text(free ? 'Запросить книгу' : 'Сейчас на руках'),
                  ),
          ),
        ],
      )),
    );
  }
}
