import 'dart:io';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as p;

void main() {
  final file = File('test-file/Alexandre Dumas - The Count of Monte Cristo - Traitor.epub');
  final bytes = file.readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(bytes);
  
  final archiveFiles = <String, List<int>>{};
  for (var file in archive) {
    if (file.isFile) {
      archiveFiles[file.name] = file.content as List<int>;
    }
  }
  
  final containerContent = archiveFiles['META-INF/container.xml'];
  if (containerContent == null) return;

  final containerXml = XmlDocument.parse(String.fromCharCodes(containerContent));
  final rootfileNode = containerXml.findAllElements('rootfile').first;
  final opfPath = rootfileNode.getAttribute('full-path')!;
  
  final opfContentBytes = archiveFiles[opfPath];
  final opfContent = String.fromCharCodes(opfContentBytes!);
  final opfXml = XmlDocument.parse(opfContent);
  final opfDir = p.dirname(opfPath);
  
  final manifestNode = opfXml.findAllElements('manifest').first;
  final manifestItems = <String, String>{};
  for (var item in manifestNode.findAllElements('item')) {
    final id = item.getAttribute('id');
    final href = item.getAttribute('href');
    if (id != null && href != null) {
      // The exact logic from local_epub_repository.dart
      final resolvedHref = p.normalize(p.join(opfDir, Uri.decodeComponent(href))).replaceAll('\\\\', '/');
      manifestItems[id] = resolvedHref;
    }
  }

  final spineNode = opfXml.findAllElements('spine').first;
  int found = 0;
  int missing = 0;
  for (var itemref in spineNode.findAllElements('itemref')) {
    final idref = itemref.getAttribute('idref')!;
    if (manifestItems.containsKey(idref)) {
      final href = manifestItems[idref]!;
      final exists = archiveFiles.containsKey(href);
      if (exists) found++; else {
        missing++;
        print('MISSING: idref=' + idref + ' href=' + href);
      }
    }
  }
  print('Found: ' + found.toString() + ' Missing: ' + missing.toString());
}
