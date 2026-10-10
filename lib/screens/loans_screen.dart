// "Мои обмены"
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../widgets/book_card.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  // текст про срок для одного обмена
  String dueText(Loan l) {
    var left = daysLeft(l);
    var text = '';
    if (l.status == 'returned') {
      text = 'Возвращена';
    } else if (l.status == 'overdue') {
      text = 'Просрочена на ' + (left * -1).toString() + ' дн.';
    } else if (left == 0) {
      text = 'Вернуть сегодня';
    } else {
      text = 'Вернуть до ${shortDate(l.dueDate)}, осталось $left дн.';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Кто у кого', style: t.headlineMedium),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: loans.length,
            separatorBuilder: (context, i) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final loan = loans[i];
              final book = bookById(loan.bookId); // по id находим саму книгу
              final lent = iLent(loan);
              final other = people[lent ? loan.borrowerId : book.ownerId]!;

              return BookCard(
                book: book,
                showStatus: false, // важнее срок, чем статус
                onTap: () => context.push('/books/${book.id}'),
                footer: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dueText(loan),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: loan.status == 'overdue' ? s.error : s.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // стрелка наружу = выдал, внутрь = взял
                        Icon(lent ? Icons.call_made : Icons.call_received, size: 16, color: s.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            lent ? 'Взял: $other' : 'Владелец: $other',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
