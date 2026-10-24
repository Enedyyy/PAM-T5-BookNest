// widgets/book_card.dart - карточка книги для списков
// используется на трёх экранах - Моя полка, Сообщество, Обмены

import 'package:flutter/material.dart';
import '../data/book.dart';
import 'book_cover.dart';
import 'status_badge.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  final Widget? footer;
  final bool showStatus;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.footer,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: s.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(18),
          right: Radius.circular(3),
        ),
        side: BorderSide(color: s.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap, // делает карточку нажимаемой
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      book.author,
                      style: t.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(book.genre, style: t.labelLarge?.copyWith(color: s.primary)),
                        if (showStatus) StatusBadge(status: book.status),
                      ],
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: 10),
                      footer!,
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // обложка справа
              BookCover(book: book),
            ],
          ),
        ),
      ),
    );
  }
}
