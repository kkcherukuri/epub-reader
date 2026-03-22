import 'dart:io';

void main() {
  final content = File('lib/presentation/ui/reader_page.dart').readAsStringSync();
  print('Contains \\\\\$? \${content.contains('\\\$')}');
  print('Matches styleInjection?');
  int idx = content.indexOf('styleInjection');
  if (idx != -1) {
    print('Char before styleInjection: \${content[idx-1]}');
    if (idx > 1) {
      print('Char 2 before: \${content[idx-2]}');
    }
  }
}
