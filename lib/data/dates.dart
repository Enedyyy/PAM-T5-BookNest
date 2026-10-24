// помощники для дат, раньше лежали в mock_data
import 'loan.dart';

// сколько дней осталось до срока
int daysLeft(Loan l) {
  final n = DateTime.now();
  final today = DateTime.utc(n.year, n.month, n.day);
  final due = DateTime.utc(l.dueDate.year, l.dueDate.month, l.dueDate.day);
  return due.difference(today).inDays;
}

String shortDate(DateTime d) {
  const months = ['янв', 'фев', 'мар', 'апр', 'мая', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
  return '${d.day} ${months[d.month - 1]}';
}
