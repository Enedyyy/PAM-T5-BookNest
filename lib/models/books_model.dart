// общее состояние книг: его читают полка, соседи, карточка, форма и профиль.
import 'package:flutter/foundation.dart';
import '../data/book.dart';
import '../data/book_repository.dart';
import '../data/result.dart';
import '../data/session.dart';

class BooksModel extends ChangeNotifier {
  BooksModel(this._repository);
  final BookRepository _repository;

  bool _loading = false;
  String? _error;
  List<Book> _books = const [];

  // фильтры полки - тоже общее состояние
  String _genre = 'Все';
  String _query = '';

  bool get isLoading => _loading;
  String? get error => _error;
  String get genre => _genre;
  List<Book> get books => List.unmodifiable(_books);

  // моя полка с учётом жанра и поиска
  List<Book> get myShelf {
    List<Book> result = [];
    var q = _query.trim().toLowerCase();
    for (var b in _books) {
      if (b.ownerId != currentUserId) continue;
      if (_genre != 'Все' && b.genre != _genre) continue;
      if (q != '' &&
          b.title.toLowerCase().contains(q) == false &&
          b.author.toLowerCase().contains(q) == false) {
        continue;
      }
      result.add(b);
    }
    return List.unmodifiable(result);
  }

  List<Book> get community {
    List<Book> result = [];
    for (var b in _books) {
      if (b.ownerId != currentUserId && b.status == BookStatus.available) {
        result.add(b);
      }
    }
    return List.unmodifiable(result);
  }

  int get myCount {
    int count = 0;
    for (var b in _books) {
      if (b.ownerId == currentUserId) count++;
    }
    return count;
  }

  // найти книгу в загруженном списке, null - если нет
  Book? byId(int id) {
    for (var b in _books) {
      if (b.id == id) return b;
    }
    return null;
  }

  void setGenre(String g) {
    _genre = g;
    notifyListeners();
  }

  void setQuery(String q) {
    _query = q;
    notifyListeners();
  }

  // загрузка: грузится -> данные или ошибка
  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners(); // экраны показывают крутилку

    switch (await _repository.fetchAll()) {
      case Ok(:final value):
        _books = value;
      case Err(:final msg):
        _error = msg;
    }

    _loading = false;
    notifyListeners(); // экраны показывают данные или ошибку
  }

  // обновление когда тянешь список вниз.
  // _loading не трогаю - иначе список пропадёт и вместо него будет большая крутилка,
  // а тут крутится маленький кружок сверху
  Future<void> refresh() async {
    switch (await _repository.fetchAll()) {
      case Ok(:final value):
        _books = value;
        _error = null;
      case Err(:final msg):
        _error = msg;
    }
    notifyListeners();
  }

  // изменения: null = всё ок, строка = текст ошибки (как у validator)
  Future<String?> add(Book draft) async {
    switch (await _repository.create(draft)) {
      case Ok(:final value):
        _books = [..._books, value]; // уже с id от хранилища
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg; // список не трогаю
    }
  }

  Future<String?> update(Book book) async {
    switch (await _repository.update(book)) {
      case Ok(:final value):
        List<Book> newList = [];
        for (var b in _books) {
          if (b.id == value.id) {
            newList.add(value);
          } else {
            newList.add(b);
          }
        }
        _books = newList;
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }

  Future<String?> remove(int id) async {
    switch (await _repository.delete(id)) {
      case Ok():
        _books = _books.where((b) => b.id != id).toList();
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }
}
