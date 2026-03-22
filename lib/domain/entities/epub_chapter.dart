class EpubChapter {
  final String id;
  final String title;
  final String href;
  final String? content;

  const EpubChapter({
    required this.id,
    required this.title,
    required this.href,
    this.content,
  });
}
