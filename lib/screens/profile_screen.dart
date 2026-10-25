// профиль: статистика из моделей + переключатель аварии + выход
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/mock_book_repository.dart';
import '../data/mock_loan_repository.dart';
import '../data/session.dart';
import '../models/books_model.dart';
import '../models/loans_model.dart';
import '../widgets/error_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _crash = false;

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Нет'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Да, выйти'),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final books = context.watch<BooksModel>();
    final loans = context.watch<LoansModel>();

    Widget stat(String value, String label) => Expanded(
          child: Column(children: [
            Text(value, style: t.headlineMedium),
            Text(label),
          ]),
        );

    Widget stats;
    if (books.isLoading || loans.isLoading) {
      stats = const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (books.error != null || loans.error != null) {
      stats = ErrorView(
        message: books.error ?? loans.error!,
        onRetry: () {
          context.read<BooksModel>().load();
          context.read<LoansModel>().load();
        },
      );
    } else {
      stats = Row(
        children: [
          stat('${books.myCount}', 'книг'),
          stat('${loans.lentCount}', 'выдано'),
          stat('${loans.borrowedCount}', 'взято'),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: Text('Профиль', style: t.headlineMedium)),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Выйти',
              onPressed: () => _logout(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentUserName, style: t.titleLarge),
                  const Text(currentUserGroup),
                  Text(currentUserEmail, style: TextStyle(color: s.onSurfaceVariant)),
                ],
              ),
            ),
            CircleAvatar(
              radius: 36,
              backgroundColor: s.tertiaryContainer,
              child: Text('ЭБ', style: t.headlineSmall?.copyWith(color: s.onTertiaryContainer)),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // плавно: крутилка -> цифры
        AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: stats),
        const SizedBox(height: 32),
        SwitchListTile(
          title: const Text('Симулировать сбой сети'),
          subtitle: const Text('включи и нажми "Повторить" на любом экране'),
          value: _crash,
          onChanged: (v) {
            setState(() => _crash = v); // галочка - только этого экрана
            context.read<MockBookRepository>().simulateError = v;
            context.read<MockLoanRepository>().simulateError = v;
          },
        ),
      ],
    );
  }
}
