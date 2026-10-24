// хранилище обменов
import 'loan.dart';
import 'loan_repository.dart';
import 'mock_data.dart';
import 'result.dart';

class MockLoanRepository implements LoanRepository {
  final List<Loan> _loans = List.of(seedLoans);
  int _nextId = 1000;
  bool simulateError = false;

  static const _latency = Duration(milliseconds: 800);
  static const _errNetwork = 'Сервер не отвечает — повторите попытку';

  @override
  Future<Result<List<Loan>>> fetchAll() async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    return Ok(List.of(_loans));
  }

  @override
  Future<Result<Loan>> fetchById(int id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    var index = _loans.indexWhere((l) => l.id == id);
    if (index == -1) return const Err('Обмен не существует');
    return Ok(_loans[index]);
  }

  @override
  Future<Result<Loan>> create(Loan loan) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    var created = loan.copyWith(id: _nextId);
    _nextId++;
    _loans.add(created);
    return Ok(created);
  }

  @override
  Future<Result<Loan>> update(Loan loan) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    var index = _loans.indexWhere((l) => l.id == loan.id);
    if (index == -1) return const Err('Обмен не существует');
    _loans[index] = loan;
    return Ok(loan);
  }

  @override
  Future<Result<void>> delete(int id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    var index = _loans.indexWhere((l) => l.id == id);
    if (index == -1) return const Err('Обмен не существует');
    _loans.removeAt(index);
    return const Ok(null);
  }
}
