import 'epub_chapter.dart';

class EpubBook {
  final String title;
  final String author;
  final String? coverImage;
  final List<EpubChapter> chapters;
  final Map<String, List<int>> archiveFiles; // In-memory file storage for web support

  const EpubBook({
    required this.title,
    required this.author,
    this.coverImage,
    required this.chapters,
    required this.archiveFiles,
  });
}
