// точка входа + корень композиции
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'data/mock_book_repository.dart';
import 'data/mock_loan_repository.dart';
import 'models/books_model.dart';
import 'models/loans_model.dart';

void main() {
  final bookRepository = MockBookRepository();
  final loanRepository = MockLoanRepository();

  runApp(
    MultiProvider(
      providers: [
        Provider<MockBookRepository>.value(value: bookRepository),
        Provider<MockLoanRepository>.value(value: loanRepository),
        ChangeNotifierProvider(create: (_) => BooksModel(bookRepository)..load()),
        ChangeNotifierProvider(create: (_) => LoansModel(loanRepository)..load()),
      ],
      child: const BookNestApp(),
    ),
  );
}

class BookNestApp extends StatelessWidget {
  const BookNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    // вся палитра сначала считается из 1 цвета
    final base = ColorScheme.fromSeed(
      seedColor: const Color(0xFFB01356),
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );

    final scheme = base.copyWith(
      surface: const Color(0xFFF6ECDD),
      surfaceContainerLow: const Color(0xFFEBDCC4),
      outline: const Color(0xFFB01356),
      primary: const Color(0xFFB01356),
      onPrimary: const Color(0xFFF6ECDD),
      primaryContainer: const Color(0xFFE9BCC9),
      onPrimaryContainer: const Color(0xFF4A0620),
      secondary: const Color(0xFF8C6B4F),
      onSecondary: const Color(0xFFF6ECDD),
      secondaryContainer: const Color(0xFFE3D2B8),
      onSecondaryContainer: const Color(0xFF3A2A12),
      tertiary: const Color(0xFFD46A93),
      onTertiary: const Color(0xFF4A0620),
      tertiaryContainer: const Color(0xFFF3CFE0),
      onTertiaryContainer: const Color(0xFF4A0620),
    );

    return MaterialApp.router(
      title: 'BookNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: scheme.surface,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: scheme.primary,
          contentTextStyle: TextStyle(color: scheme.onPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      routerConfig: router,
    );
  }
}
