// контракт хранилища обменов, по тому же шаблону что и книги
import 'loan.dart';
import 'result.dart';

abstract class LoanRepository {
  Future<Result<List<Loan>>> fetchAll();
  Future<Result<Loan>> fetchById(int id);
  Future<Result<Loan>> create(Loan loan);
  Future<Result<Loan>> update(Loan loan); // тут же и возврат книги
  Future<Result<void>> delete(int id);
}
