import 'dart:io';
import 'lib/data/repositories/local_epub_repository.dart';

void main() async {
  final repo = LocalEpubRepository();
  final file = File('test-file/Alexandre Dumas - The Count of Monte Cristo - Traitor.epub');
  final bytes = file.readAsBytesSync();
  
  try {
    final book = await repo.parseEpub(bytes);
    print('Successfully parsed book: \${book.title}');
    print('Author: \${book.author}');
    print('Number of chapters: \${book.chapters.length}');
    
    // Verify paths exist in archive
    int missing = 0;
    for (var chapter in book.chapters) {
      if (!book.archiveFiles.containsKey(chapter.href)) {
        missing++;
        print('MISSING CHAPTER IN ARCHIVE: \${chapter.href}');
      }
    }
    
    if (missing == 0 && book.chapters.isNotEmpty) {
      print('VERIFICATION SUCCESS: All chapters correctly resolved!');
    } else {
      print('VERIFICATION FAILED: \$missing chapters missing from archive mapping.');
    }
  } catch (e, st) {
    print('Error parsing EPUB: \$e\\n\$st');
  }
}
