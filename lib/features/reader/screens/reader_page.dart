import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import '../../../domain/entities/epub_book.dart';

class ReaderPage extends StatefulWidget {
  final EpubBook book;
  final int initialChapterIndex;

  const ReaderPage({
    super.key,
    required this.book,
    this.initialChapterIndex = 0,
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  late final WebViewController _controller;
  late int _currentIndex;
  bool _showUI = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialChapterIndex;
    
    _controller = WebViewController();
    try {
      _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      _controller.addJavaScriptChannel('EpubInteract', onMessageReceived: (message) {
        if (message.message == 'tap') {
          setState(() => _showUI = !_showUI);
        }
      });
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-load chapter to apply latest theme/typography when context changes
    _loadChapter(_currentIndex);
  }

  Future<void> _loadChapter(int index) async {
    if (index < 0 || index >= widget.book.chapters.length) return;
    setState(() => _currentIndex = index);

    final chapter = widget.book.chapters[_currentIndex];
    final chapterBytes = widget.book.archiveFiles[chapter.href];
    
    if (chapterBytes == null) {
      _controller.loadHtmlString('<html><body><h1>Chapter not found</h1></body></html>');
      return;
    }

    String htmlContent = utf8.decode(chapterBytes, allowMalformed: true);
    final chapterDir = p.posix.dirname(chapter.href);
    
    // Inject exact modern typography and dark mode bindings via CSS
    // This fully bypasses the webview_flutter Web NavigationDelegate Unimplemented bugs!
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgHex = isDark ? '#0A0A0A' : '#FAFAFA';
    final textHex = isDark ? '#E5E7EB' : '#111827';
    final linkHex = isDark ? '#818CF8' : '#4F46E5';

    final styleInjection = '''
      <style>
        body {
          background-color: $bgHex !important;
          color: $textHex !important;
          font-family: 'Outfit', -apple-system, sans-serif !important;
          font-size: 20px !important;
          line-height: 1.8 !important;
          max-width: 800px !important;
          margin: 0 auto !important;
          overflow-x: hidden !important;
          word-wrap: break-word !important;
          padding: 80px 24px 120px 24px !important;
        }
        a {
          color: $linkHex !important;
          text-decoration: none !important;
        }
        img {
          max-width: 100% !important;
          border-radius: 12px !important;
          margin: 16px 0 !important;
          display: block !important;
        }
      </style>
    ''';

    if (htmlContent.contains('</head>')) {
      htmlContent = htmlContent.replaceFirst('</head>', '\n$styleInjection\n</head>');
    } else {
      htmlContent = '$styleInjection\n$htmlContent';
    }

    final scriptInjection = '''
      <script>
        document.addEventListener('click', function(e) {
          if (e.target.tagName !== 'A') {
            if (typeof EpubInteract !== 'undefined') {
              EpubInteract.postMessage('tap');
            }
          }
        });
      </script>
    ''';
    if (htmlContent.contains('</body>')) {
      htmlContent = htmlContent.replaceFirst('</body>', '$scriptInjection\n</body>');
    } else {
      htmlContent = '$htmlContent\n$scriptInjection';
    }

    // Inject absolute image base64 data
    htmlContent = htmlContent.replaceAllMapped(RegExp(r'src="([^"]+)"'), (match) {
      final src = match.group(1)!;
      if (src.startsWith('http') || src.startsWith('data:')) return match.group(0)!;
      final imagePath = p.posix.normalize(p.posix.join(chapterDir, Uri.decodeComponent(src)));
      final imgBytes = widget.book.archiveFiles[imagePath];
      if (imgBytes != null) {
        final ext = p.extension(imagePath).toLowerCase().replaceAll('.', '');
        final mimeType = ext == 'png' ? 'image/png' : (ext == 'jpg' || ext == 'jpeg' ? 'image/jpeg' : 'image/svg+xml');
        return 'src="data:$mimeType;base64,${base64Encode(imgBytes)}"';
      }
      return match.group(0)!; 
    });

    _controller.loadHtmlString(htmlContent);

    // Save Last-Read state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_read_${widget.book.title}', _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.book.chapters.isEmpty) return const Scaffold();
    
    final currentChapter = widget.book.chapters[_currentIndex];

    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: false,
      appBar: _showUI ? AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.95),
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(widget.book.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey)),
            Text(currentChapter.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ) : null,
      body: WebViewWidget(controller: _controller),
      bottomNavigationBar: _showUI ? BottomAppBar(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded),
              iconSize: 32,
              color: _currentIndex > 0 ? Theme.of(context).colorScheme.primary : Colors.grey,
              onPressed: _currentIndex > 0 ? () => _loadChapter(_currentIndex - 1) : null,
            ),
            Text('${_currentIndex + 1} / ${widget.book.chapters.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              iconSize: 32,
              color: _currentIndex < widget.book.chapters.length - 1 ? Theme.of(context).colorScheme.primary : Colors.grey,
              onPressed: _currentIndex < widget.book.chapters.length - 1 ? () => _loadChapter(_currentIndex + 1) : null,
            ),
          ],
        ),
      ) : null,
    );
  }
}
