// точка входа - тема приложения и первый экран
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() => runApp(const BookNestApp());

class BookNestApp extends StatelessWidget {
  const BookNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    // вся палитра считается из 1 цвета
    // vibrant = цвета насыщеннее. seedColor + hot reload = перекрасится всё
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3A46D6),
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );

    return MaterialApp(
      title: 'BookNest',
      debugShowCheckedModeBanner: false, // убираю ленту DEBUG
      theme: ThemeData(colorScheme: scheme),
      home: const LoginScreen(), // первый экран - вход
    );
  }
}