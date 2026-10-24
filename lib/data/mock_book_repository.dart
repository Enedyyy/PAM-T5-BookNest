// хранилище книг "понарошку": список в памяти, но ведёт себя как сеть -
// отвечает с задержкой и умеет падать (переключатель в профиле)
import 'book.dart';
import 'book_repository.dart';
import 'mock_data.dart';
import 'result.dart';

class MockBookRepository implements BookRepository {
  final List<Book> _books = List.of(seedBooks); // копия стартовых данных
  int _nextId = 1000;
  bool simulateError = false;

  static const _latency = Duration(seconds: 4); // без задержки не увидеть
  static const _errNetwork = 'Сервер не отвечает — повторите попытку';

  @override
  Future<Result<List<Book>>> fetchAll() async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    return Ok(List.of(_books)); // отдаю копию, свой список наружу не даю
  }

  @override
  Future<Result<Book>> fetchById(int id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    var index = _books.indexWhere((b) => b.id == id);
    if (index == -1) return const Err('Книга не существует'); // как 404 на сервере
    return Ok(_books[index]);
  }

  @override
  Future<Result<Book>> create(Book book) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    var created = book.copyWith(id: _nextId); // id даёт хранилище, а не экран
    _nextId++;
    _books.add(created);
    return Ok(created);
  }

  @override
  Future<Result<Book>> update(Book book) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    var index = _books.indexWhere((b) => b.id == book.id);
    if (index == -1) return const Err('Книга не существует');
    _books[index] = book;
    return Ok(book);
  }

  @override
  Future<Result<void>> delete(int id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    var index = _books.indexWhere((b) => b.id == id);
    if (index == -1) return const Err('Книга не существует');
    _books.removeAt(index);
    return const Ok(null); // удалил, отдавать нечего
  }
}
