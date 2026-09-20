//  форма новой книги / редактирования
import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class BookFormScreen extends StatelessWidget {
  final Book? book; // ? значит может быть null. null = новая книга
  const BookFormScreen({super.key, this.book});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(book == null ? 'Новая книга' : 'Редактирование')),
      // ListView, а не Column, чтобы экран прокручивался когда открыта клавиатура
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // место под обложку
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: s.surfaceContainerLow,
              border: Border.all(color: s.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined, size: 36, color: s.primary),
                const Text('Выбрать обложку'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Название',
              hintText: book?.title ?? 'Например, Дюна', // ?? = если null, берём запасной
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Автор',
              hintText: book?.author ?? 'Например, Фрэнк Герберт',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // выпадающий список жанров. skip(1) пропускает "Все", он нужен только фильтру
          DropdownMenu<String>(
            label: const Text('Жанр'),
            expandedInsets: EdgeInsets.zero, // на всю ширину
            initialSelection: book?.genre,
            dropdownMenuEntries: [
              for (final g in genres.skip(1)) DropdownMenuEntry(value: g, label: g),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {}, // сохранения пока нет
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
