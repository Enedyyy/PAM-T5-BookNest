//  карточка книги
// автор, жанр, обложка, статус (доступна / выдана)
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/book_cover.dart';
import '../widgets/status_badge.dart';
import 'book_form_screen.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book; // какую книгу показываем, приходит из списка
  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final mine = book.ownerId == currentUserId; // моя книга или чужая
    final free = book.status == BookStatus.available;
    final loan = activeLoanOf(book.id); // если книга выдана, тут будет обмен

    return Scaffold(
      appBar: AppBar(title: const Text('О книге')),
      body: ListView(
        children: [
          // цветной блок: текст слева, обложка справа
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
          // инфо строками. ListTile - готовая строка: иконка, текст, подпись
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(book.genre),
            subtitle: const Text('Жанр'),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(mine ? 'Я' : people[book.ownerId]!), // ! = точно не null
            subtitle: const Text('Владелец'),
          ),
          // эта строка есть только если книга выдана
          if (loan != null)
            ListTile(
              leading: const Icon(Icons.event_outlined),
              title: Text(shortDate(loan.dueDate)),
              subtitle: const Text('Вернуть до'),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            // для своей книги - "Редактировать", для чужой - "Запросить"
            child: mine
                ? OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BookFormScreen(book: book)),
                    ),
                    child: const Text('Редактировать'),
                  )
                : FilledButton(
                    onPressed: free ? () {} : null, // null = кнопка серая и не нажимается
                    child: Text(free ? 'Запросить книгу' : 'Сейчас на руках'),
                  ),
          ),
        ],
      ),
    );
  }
}
