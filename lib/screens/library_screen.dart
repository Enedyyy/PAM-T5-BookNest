// "библиотека"
// поиск + фильтр по жанру + список книг, пока для вида
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';
import 'book_form_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      children: [
        // заголовок слева, кнопка добавить справа
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 12, 8),
          child: Row(
            children: [
              Expanded(child: Text('Моя полка', style: t.headlineMedium)),
              IconButton.filled(
                icon: const Icon(Icons.add),
                tooltip: 'Добавить книгу',
                // открываем форму новой книги
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookFormScreen()),
                ),
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
        // ряд жанров, листается вбок
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: genres.length,
            separatorBuilder: (context, i) => const SizedBox(width: 8),
            itemBuilder: (context, i) => ChoiceChip(
              label: Text(genres[i]),
              selected: i == 0, // пока выбрано только Все
              onSelected: (_) {}, // не работает пока
            ),
          ),
        ),
        // список книг. Expanded нужен, иначе ListView внутри Column не знает высоту
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: myBooks.length,
            separatorBuilder: (context, i) => const SizedBox(height: 10), // расстояние между карточками
            itemBuilder: (context, i) {
              final book = myBooks[i];
              return BookCard(
                book: book,
                // по нажатию открываем карточку этой книги
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
