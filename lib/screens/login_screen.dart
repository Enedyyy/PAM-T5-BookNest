//  вход / регистрация
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    // высоты "книг" для полки
    final heights = [90.0, 120.0, 80.0, 110.0, 100.0, 75.0, 115.0];
    // цвета книг
    final colors = [s.onPrimary, s.tertiaryContainer, s.secondaryContainer];

    return Scaffold(
      // значки статус-бара светлые, иначе на синем их не видно
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: ListView(
          padding: EdgeInsets.zero, // без этого ListView сам добавит отступ сверху
          children: [
            // синий блок сверху
            Container(
              width: double.infinity,
              // отступ сверху иначе полка прилипает к низу
              padding: EdgeInsets.fromLTRB(28, MediaQuery.of(context).padding.top + 36, 28, 0),
              decoration: BoxDecoration(
                color: s.primary,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(56)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BookNest', style: t.displaySmall?.copyWith(color: s.onPrimary)),
                  const SizedBox(height: 6),
                  Text(
                    'Книги должны ходить по рукам',
                    style: t.titleMedium?.copyWith(color: s.primaryContainer),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (var i = 0; i < heights.length; i++)
                        Container(
                          width: 22,
                          height: heights[i],
                          margin: const EdgeInsets.only(right: 3),
                          color: colors[i % colors.length], // цвета по кругу
                        ),
                    ],
                  ),
                  // доска, на которой стоят книги
                  Container(height: 10, color: s.onPrimary),
                ],
              ),
            ),
            // форма входа
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  const TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      suffixIcon: Icon(Icons.alternate_email), // иконка справа
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    obscureText: true, // вместо букв точки
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      suffixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity, // кнопка на всю ширину
                    child: FilledButton(
                      //  идем дальше на главный экран
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeShell()),
                      ),
                      child: const Text('Войти'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {}, // регистрация пока ничего не делает
                    child: const Text('Нет аккаунта? Зарегистрируйтесь'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
