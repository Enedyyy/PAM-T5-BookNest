//  вход / регистрация
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/paper_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    var isOk = _formKey.currentState!.validate();
    if (isOk == false) {
      return;
    }

    context.go('/library');
  }

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final heights = [90.0, 120.0, 80.0, 110.0, 100.0, 75.0, 115.0];
    final colors = [s.onPrimary, s.tertiaryContainer, s.secondaryContainer];

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: PaperBackground(child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
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
                  Text('..............', style: t.titleMedium?.copyWith(color: s.primaryContainer)),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (var i = 0; i < heights.length; i++)
                        Container(
                          width: 22,
                          height: heights[i],
                          margin: const EdgeInsets.only(right: 3),
                          color: colors[i % colors.length],
                        ),
                    ],
                  ),
                  Container(height: 10, color: s.onPrimary),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        suffixIcon: Icon(Icons.alternate_email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null) {
                          return 'E-mail обязателен';
                        }
                        if (v.trim() == '') {
                          return 'E-mail обязателен';
                        }
                        if (v.contains('@') == false) {
                          return 'Похоже, это не e-mail';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Пароль',
                        suffixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.length < 6) {
                          return 'Минимум 6 символов';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(onPressed: _login, child: const Text('Войти')),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Нет аккаунта? Зарегистрируйтесь'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
