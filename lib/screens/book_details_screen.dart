//  карточка книги
// автор, жанр, обложка, статус (доступна / выдана)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../widgets/book_cover.dart';
import '../widgets/status_badge.dart';
import '../widgets/paper_background.dart';

class BookDetailsScreen extends StatelessWidget {
  final int id;
  const BookDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final book = bookById(id); // ищу книгу по id прямо в экране
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final mine = book.ownerId == currentUserId; // моя книга или чужая
    bool free = false;
    if (book.status == BookStatus.available) free = true;
    final loan = activeLoanOf(book.id);

    String ownerName;
    if (mine) {
      ownerName = 'Я';
    } else {
      ownerName = people[book.ownerId]!;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('О книге')),
      // этот экран не во вкладках, поэтому бумагу добавляю тут отдельно
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
                ? OutlinedButton(
                    onPressed: () => context.push('/books/${book.id}/edit'),
                    child: const Text('Редактировать'),
                  )
                : FilledButton(
                    onPressed: free
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Запрос отправлен: ${book.title}')),
                            );
                          }
                        : null, // null = кнопка серая и не нажимается
                    child: Text(free ? 'Запросить книгу' : 'Сейчас на руках'),
                  ),
          ),
        ],
      )),
    );
  }
}
