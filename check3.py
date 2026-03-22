with open('lib/presentation/ui/reader_page.dart', 'r', encoding='utf-8') as f:
    content = f.read()

idx = content.find('styleInjection', 2080)
if idx != -1:
    print([ord(c) for c in content[idx-4:idx+3]])
