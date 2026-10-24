// контракт хранилища книг
import 'book.dart';
import 'result.dart';

abstract class BookRepository {
  Future<Result<List<Book>>> fetchAll();
  Future<Result<Book>> fetchById(int id);
  Future<Result<Book>> create(Book book);
  Future<Result<Book>> update(Book book);
  Future<Result<void>> delete(int id); // удалил - отдавать нечего
}
