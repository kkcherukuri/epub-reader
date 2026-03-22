import 'package:path/path.dart' as p;

void main() {
  var opfDir = p.dirname('content.opf');
  var href = Uri.decodeComponent('OEBPS/Text/chapter.html');
  
  var pJoin = p.join(opfDir, href);
  var pNormalize = p.normalize(pJoin);
  var pReplace = pNormalize.replaceAll('\\\\', '/');
  
  print('Normal path join: ' + pJoin);
  print('Normal path normalize: ' + pNormalize);
  print('Normal path replace: ' + pReplace);
  
  var opfDirPosix = p.posix.dirname('content.opf');
  var pJoinPosix = p.posix.join(opfDirPosix, href);
  var pNormalizePosix = p.posix.normalize(pJoinPosix);
  
  print('Posix path join: ' + pJoinPosix);
  print('Posix path normalize: ' + pNormalizePosix);
}
