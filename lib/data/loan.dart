// обмен: кто какую книгу взял и до какого числа
import 'session.dart';

class Loan {
  final int id;
  final int bookId;
  final int borrowerId; // кто взял
  final String borrowerName;
  final DateTime startDate;
  final DateTime dueDate; // до какого числа вернуть
  final String status;

  Loan(this.id, this.bookId, this.borrowerId, this.borrowerName, this.startDate,
      this.dueDate, this.status);

  bool get lentByMe => borrowerId != currentUserId;

  Loan copyWith({int? id, String? status}) {
    return Loan(id ?? this.id, bookId, borrowerId, borrowerName, startDate, dueDate,
        status ?? this.status);
  }
}
