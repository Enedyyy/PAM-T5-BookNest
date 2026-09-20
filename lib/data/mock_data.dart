
// книга или лежит дома (available), или отдана кому-то (lent)
enum BookStatus { available, lent }

// книга
class Book {
  final int id;
  final int ownerId; // чья книга
  final String title;
  final String author;
  final String genre;
  final String coverUrl; // обложку рисую сам
  final BookStatus status;

  const Book(this.id, this.ownerId, this.title, this.author, this.genre,
      this.coverUrl, this.status);
}

// обмен
// status: 'active' (идёт), 'overdue' (просрочен), 'returned' (вернули)
class Loan {
  final int id;
  final int bookId;
  final int borrowerId; // кто взял
  final DateTime startDate;
  final DateTime dueDate; // до какого числа вернуть
  final String status;

  // тут нет const, потому что DateTime const быть не может
  Loan(this.id, this.bookId, this.borrowerId, this.startDate, this.dueDate,
      this.status);
}

const currentUserId = 1; // эт я

// id человека -> имя
const people = {
  1: 'Эдуард',
  2: 'Ана Русу',
  3: 'Влад Чебан',
  4: 'Мария Попеску',
  5: 'Дмитрий Ковальчук',
  6: 'Кристина Лунгу',
};

// жанры для фильтра
const genres = ['Все', 'Классика', 'Фантастика', 'IT', 'Наука', 'Психология', 'Детектив'];

// мои книги (ownerId = 1)
const myBooks = [
  Book(1, 1, 'Мастер и Маргарита', 'Михаил Булгаков', 'Классика', '', BookStatus.available),
  Book(2, 1, 'Clean Code', 'Robert C. Martin', 'IT', '', BookStatus.lent),
  Book(3, 1, 'Дюна', 'Фрэнк Герберт', 'Фантастика', '', BookStatus.available),
  Book(4, 1, 'Sapiens: Краткая история человечества', 'Юваль Ной Харари', 'Наука', '', BookStatus.lent),
  Book(5, 1, 'Преступление и наказание', 'Фёдор Достоевский', 'Классика', '', BookStatus.lent),
  Book(6, 1, 'Думай медленно… решай быстро', 'Даниэль Канеман', 'Психология', '', BookStatus.available),
  // очень длинное название специально, мб че и вылезет
  Book(7, 1, 'Философия Java: полное руководство для программистов, четвёртое переработанное издание', 'Брюс Эккель', 'IT', '', BookStatus.available),
  Book(8, 1, 'Убийство в «Восточном экспрессе»', 'Агата Кристи', 'Детектив', '', BookStatus.available),
];

// книги других людей
const communityBooks = [
  Book(11, 2, 'Три товарища', 'Эрих Мария Ремарк', 'Классика', '', BookStatus.available),
  Book(12, 3, 'Задача трёх тел', 'Лю Цысинь', 'Фантастика', '', BookStatus.available),
  Book(13, 3, 'Совершенный код', 'Стив Макконнелл', 'IT', '', BookStatus.available),
  Book(14, 4, 'Атомные привычки', 'Джеймс Клир', 'Психология', '', BookStatus.available),
  Book(15, 5, 'Краткая история времени', 'Стивен Хокинг', 'Наука', '', BookStatus.available),
  Book(16, 2, 'Собачье сердце', 'Михаил Булгаков', 'Классика', '', BookStatus.available),
  Book(17, 6, 'Убийство Роджера Экройда', 'Агата Кристи', 'Детектив', '', BookStatus.available),
  Book(18, 4, 'Рефакторинг. Улучшение существующего кода', 'Мартин Фаулер', 'IT', '', BookStatus.available),
  // эти три сейчас у меня на руках , в сообществе их не показываю
  Book(21, 5, 'Скотный двор', 'Джордж Оруэлл', 'Классика', '', BookStatus.lent),
  Book(22, 6, 'Шерлок Холмс. Собрание рассказов', 'Артур Конан Дойл', 'Детектив', '', BookStatus.lent),
  Book(23, 4, 'Маленький принц', 'Антуан де Сент-Экзюпери', 'Классика', '', BookStatus.lent),
];

// один общий список, чтобы искать книгу по id
final allBooks = [...myBooks, ...communityBooks];

// дата "сегодня + shift дней" (минус = в прошлом)
DateTime _day(int shift) {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day + shift);
}

// Loan(id, bookId, borrowerId, старт, срок, статус)
// даты считаю от сегодня, чтобы просрочка всегда была нормальной
// первые три - я выдал (borrowerId не я), следующие три - я взял (borrowerId = 1)
final loans = [
  Loan(1, 2, 3, _day(-10), _day(4), 'active'),
  Loan(2, 4, 2, _day(-20), _day(1), 'active'),
  Loan(3, 5, 5, _day(-30), _day(-3), 'overdue'),
  Loan(4, 21, 1, _day(-8), _day(6), 'active'),
  Loan(5, 22, 1, _day(-25), _day(-4), 'overdue'),
  Loan(6, 23, 1, _day(-12), _day(2), 'active'),
  // история: эти уже вернули (3 выдал, 3 взял)
  Loan(7, 1, 4, _day(-60), _day(-46), 'returned'),
  Loan(8, 3, 2, _day(-45), _day(-31), 'returned'),
  Loan(9, 6, 3, _day(-90), _day(-76), 'returned'),
  Loan(10, 11, 1, _day(-70), _day(-56), 'returned'),
  Loan(11, 12, 1, _day(-50), _day(-36), 'returned'),
  Loan(12, 13, 1, _day(-40), _day(-26), 'returned'),
];

// найти книгу по id
Book bookById(int id) => allBooks.firstWhere((b) => b.id == id);

// если брал не я - значит выдал я
bool iLent(Loan l) => l.borrowerId != currentUserId;

// текущий не возвращённыйобмен по книге, или null если такого нет
Loan? activeLoanOf(int bookId) {
  for (final l in loans) {
    if (l.bookId == bookId && l.status != 'returned') return l;
  }
  return null;
}

// сколько дней осталось до срока
// беру UTC, чтобы переход на зимнее/летнее время не ломал
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
