import 'package:archive/archive.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as p;
import '../../domain/entities/epub_book.dart';
import '../../domain/entities/epub_chapter.dart';
import '../../domain/repositories/epub_repository.dart';

class LocalEpubRepository implements EpubRepository {
  @override
  Future<EpubBook> parseEpub(List<int> bytes) async {
    final archive = ZipDecoder().decodeBytes(bytes);
    final Map<String, List<int>> archiveFiles = {};
    
    for (var file in archive) {
      if (file.isFile) {
        archiveFiles[file.name] = file.content as List<int>;
      }
    }

    final containerContent = archiveFiles['META-INF/container.xml'];
    if (containerContent == null) {
      throw Exception('META-INF/container.xml not found. Invalid EPUB.');
    }

    final containerXml = XmlDocument.parse(String.fromCharCodes(containerContent));
    final rootfileNode = containerXml.findAllElements('rootfile').first;
    final opfPath = rootfileNode.getAttribute('full-path');
    
    if (opfPath == null) throw Exception('OPF path not found in container.xml');
    
    final opfContentBytes = archiveFiles[opfPath];
    if (opfContentBytes == null) throw Exception('OPF file not found: $opfPath');
    
    final opfContent = String.fromCharCodes(opfContentBytes);
    final opfXml = XmlDocument.parse(opfContent);
    final opfDir = p.dirname(opfPath);
    
    // Parse metadata
    final metadataNodes = opfXml.findAllElements('metadata');
    if (metadataNodes.isEmpty) throw Exception('No metadata found in OPF');
    
    final metadataNode = metadataNodes.first;
    final titleNode = metadataNode.findAllElements('dc:title').firstOrNull;
    final authorNode = metadataNode.findAllElements('dc:creator').firstOrNull;
    
    final title = titleNode?.innerText ?? 'Unknown Title';
    final author = authorNode?.innerText ?? 'Unknown Author';
    
    // Parse manifest
    final manifestNode = opfXml.findAllElements('manifest').first;
    final Map<String, String> manifestItems = {};
    for (var item in manifestNode.findAllElements('item')) {
      final id = item.getAttribute('id');
      final href = item.getAttribute('href');
      if (id != null && href != null) {
        // Keep paths uniform with forward slashes
        final resolvedHref = p.normalize(p.join(opfDir, Uri.decodeComponent(href))).replaceAll('\\', '/');
        manifestItems[id] = resolvedHref;
      }
    }
    
    // Parse spine
    final spineNode = opfXml.findAllElements('spine').first;
    final List<EpubChapter> chapters = [];
    
    int index = 0;
    for (var itemref in spineNode.findAllElements('itemref')) {
      final idref = itemref.getAttribute('idref');
      if (idref != null && manifestItems.containsKey(idref)) {
        chapters.add(EpubChapter(
          id: idref,
          title: 'Chapter ${index + 1}', 
          href: manifestItems[idref]!,
        ));
        index++;
      }
    }

    return EpubBook(
      title: title,
      author: author,
      chapters: chapters,
      archiveFiles: archiveFiles,
    );
  }
}
