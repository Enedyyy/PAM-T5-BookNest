// точка входа
import 'package:flutter/material.dart';
import 'router.dart';

void main() => runApp(const BookNestApp());

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
      ),
      routerConfig: router,
    );
  }
}
