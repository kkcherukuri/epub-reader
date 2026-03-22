import 'package:path/path.dart' as p;

void main() {
  var opfDir = p.dirname('content.opf');
  var href = Uri.decodeComponent('Text/chapter.html');
  
  var pJoin = p.join(opfDir, href);
  var pNormalize = p.normalize(pJoin);
  var pReplace = pNormalize.replaceAll('\\', '/');
  
  print('Root OPF path replace: ' + pReplace);
  
  // Posix variant
  var posixReplace = p.posix.normalize(p.posix.join(p.posix.dirname('content.opf'), href)).replaceAll('\\', '/');
  print('Posix Root OPF path: ' + posixReplace);
}
