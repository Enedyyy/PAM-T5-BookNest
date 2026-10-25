// "Мои обмены" - только текущие, возвращённые не показываю
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/book.dart';
import '../data/dates.dart';
import '../data/loan.dart';
import '../models/books_model.dart';
import '../models/loans_model.dart';
import '../widgets/book_card.dart';
import '../widgets/error_view.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  String dueText(Loan l) {
    var left = daysLeft(l);
    var text = '';
    if (l.status == 'overdue') {
      text = 'Просрочена на ' + (left * -1).toString() + ' дн.';
    } else if (left == 0) {
      text = 'Вернуть сегодня';
    } else {
      text = 'Вернуть до ${shortDate(l.dueDate)}, осталось $left дн.';
    }
    return text;
  }

  Widget dueChip(BuildContext context, Loan l) {
    final s = Theme.of(context).colorScheme;
    var left = daysLeft(l);
    Color bg;
    Color fg;
    if (l.status == 'overdue') {
      bg = s.errorContainer;
      fg = s.onErrorContainer;
    } else if (left <= 3) {
      bg = s.primaryContainer;
      fg = s.onPrimaryContainer;
    } else {
      bg = s.secondaryContainer;
      fg = s.onSecondaryContainer;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(dueText(l), style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }

  Future<bool> _returnBook(BuildContext context, Loan loan, Book book) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Книгу вернули?'),
        content: Text(book.title),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text('Нет')),
          FilledButton(onPressed: () => Navigator.pop(dialogCtx, true), child: const Text('Да')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return false;

    final error = await context.read<LoansModel>().returnLoan(loan);
    if (!context.mounted) return false;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return false;
    }

    await context.read<BooksModel>().update(book.copyWith(status: BookStatus.available));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final loansModel = context.watch<LoansModel>();
    final booksModel = context.watch<BooksModel>();

    Widget body;
    if (loansModel.isLoading || booksModel.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (loansModel.error != null || booksModel.error != null) {
      body = ErrorView(
        message: loansModel.error ?? booksModel.error!,
        onRetry: () {
          context.read<LoansModel>().load();
          context.read<BooksModel>().load();
        },
      );
    } else {
      final list = loansModel.active;
      if (list.isEmpty) {
        body = const Center(child: Text('Сейчас обменов нет'));
      } else {
        body = RefreshIndicator(
          color: s.primary,

          onRefresh: () async {
            await context.read<LoansModel>().refresh();
            if (!context.mounted) return;
            await context.read<BooksModel>().refresh();
          },
          child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: list.length,
          separatorBuilder: (_, i) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final loan = list[i];
            final book = booksModel.byId(loan.bookId);
            if (book == null) return const SizedBox.shrink();
            final lent = loan.lentByMe;
            final other = lent ? loan.borrowerName : book.ownerName;

            return Dismissible(
              key: ValueKey(loan.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) => _returnBook(context, loan, book),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: s.primaryContainer,
                child: Text('Вернули', style: TextStyle(color: s.onPrimaryContainer, fontWeight: FontWeight.w700)),
              ),
              child: BookCard(
                book: book,
                showStatus: false,
                onTap: () => context.push('/books/${book.id}'),
                footer: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dueChip(context, loan),
                    const SizedBox(height: 4),
                    Row(
                      children: [

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
              ),
            );
          },
        ),
        );
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Кто у кого', style: t.headlineMedium),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('смахни влево, когда книгу вернули'),
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: body),
        ),
      ],
    );
  }
}
