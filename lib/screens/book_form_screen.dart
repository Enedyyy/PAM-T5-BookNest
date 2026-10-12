//  форма новой книги / редактирования
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../widgets/paper_background.dart';

class BookFormScreen extends StatefulWidget {
  final int? id;
  const BookFormScreen({super.key, this.id});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _authorCtrl;
  String? _genre;

  Book? get _book => widget.id == null ? null : bookById(widget.id!);

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: _book?.title ?? '');
    _authorCtrl = TextEditingController(text: _book?.author ?? '');
    _genre = _book?.genre;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate() == false) return;
    String name = _titleCtrl.text;
    name = name.trim();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Сохранено: ' + name)));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;

    String title = 'Новая книга';
    if (_book != null) {
      title = 'Редактирование';
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),

      body: PaperBackground(child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
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
            TextFormField(
              controller: _titleCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Название'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Название обязательно';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorCtrl,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Автор'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Автор обязателен';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // у выпадающего списка (DropdownButtonFormField) тоже есть validator -
            // жанр нельзя оставить пустым
            DropdownButtonFormField<String>(
              value: _genre,
              decoration: const InputDecoration(labelText: 'Жанр'),
              // sublist(1) - первый это 'Все', в форме он не нужен
              items: genres.sublist(1).map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => _genre = v),
              validator: (v) => v == null ? 'Выберите жанр' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Сохранить')),
          ],
        ),
      )),
    );
  }
}
