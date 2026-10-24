// общее состояние обменов
// карточка книги и профиль
import 'package:flutter/foundation.dart';
import '../data/book.dart';
import '../data/loan.dart';
import '../data/loan_repository.dart';
import '../data/result.dart';
import '../data/session.dart';

class LoansModel extends ChangeNotifier {
  LoansModel(this._repository);
  final LoanRepository _repository;

  bool _loading = false;
  String? _error;
  List<Loan> _loans = const [];

  bool get isLoading => _loading;
  String? get error => _error;
  List<Loan> get loans => List.unmodifiable(_loans);

  // только текущие обмены, без возвращённых
  List<Loan> get active => List.unmodifiable(_loans.where((l) => l.status != 'returned'));

  int get activeCount => active.length; // для значка на вкладке

  int get lentCount {
    int n = 0;
    for (var l in active) {
      if (l.lentByMe) n++;
    }
    return n;
  }

  int get borrowedCount => activeCount - lentCount;

  // текущий обмен по книге, если она сейчас у кого-то
  Loan? activeLoanOf(int bookId) {
    for (var l in active) {
      if (l.bookId == bookId) return l;
    }
    return null;
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    switch (await _repository.fetchAll()) {
      case Ok(:final value):
        _loans = value;
      case Err(:final msg):
        _error = msg;
    }

    _loading = false;
    notifyListeners();
  }

  // обновление потягиванием, так же как в BooksModel
  Future<void> refresh() async {
    switch (await _repository.fetchAll()) {
      case Ok(:final value):
        _loans = value;
        _error = null;
      case Err(:final msg):
        _error = msg;
    }
    notifyListeners();
  }

  // кнопка Запросить книгу
  Future<String?> request(Book book) async {
    var now = DateTime.now();
    var draft = Loan(0, book.id, currentUserId, currentUserName, now,
        DateTime(now.year, now.month, now.day + 14), 'active'); // id 0 - настоящий даст хранилище

    switch (await _repository.create(draft)) {
      case Ok(:final value):
        _loans = [..._loans, value];
        notifyListeners(); // значок  вырастет сам
        return null;
      case Err(:final msg):
        return msg;
    }
  }

  // книгу вернули - статус returned
  Future<String?> returnLoan(Loan loan) async {
    switch (await _repository.update(loan.copyWith(status: 'returned'))) {
      case Ok(:final value):
        List<Loan> newList = [];
        for (var l in _loans) {
          if (l.id == value.id) {
            newList.add(value);
          } else {
            newList.add(l);
          }
        }
        _loans = newList;
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }
}
