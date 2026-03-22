import 'package:path/path.dart' as p;

void main() {
  var opfDir = p.dirname('content.opf');
  var href = Uri.decodeComponent('OEBPS/Text/chapter.html');
  
  var pJoin = p.join(opfDir, href);
  var pNormalize = p.normalize(pJoin);
  var pReplace = pNormalize.replaceAll('\\', '/');
  
  print('Normal path replace: ' + pReplace);
}
