import '../entities/epub_book.dart';

abstract class EpubRepository {
  /// Parses the EPUB from raw [bytes] and returns an [EpubBook] entity.
  Future<EpubBook> parseEpub(List<int> bytes);
}
