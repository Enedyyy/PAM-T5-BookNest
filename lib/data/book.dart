// книга - главная сущность темы
enum BookStatus { available, lent } // лежит дома / отдана кому-то

// жанры для фильтра и для формы
const genres = ['Все', 'Классика', 'Фантастика', 'IT', 'Наука', 'Психология', 'Детектив'];

class Book {
  final int id;
  final int ownerId; // чья книга
  final String ownerName; // имя владельца, раньше брал из people
  final String title;
  final String author;
  final String genre;
  final String coverUrl; // обложка, пока пустая
  final BookStatus status;

  const Book(this.id, this.ownerId, this.ownerName, this.title, this.author,
      this.genre, this.coverUrl, this.status);

  // та же книга, но с другими полями
  Book copyWith({int? id, String? title, String? author, String? genre, BookStatus? status}) {
    return Book(
      id ?? this.id,
      ownerId,
      ownerName,
      title ?? this.title,
      author ?? this.author,
      genre ?? this.genre,
      coverUrl,
      status ?? this.status,
    );
  }
}
