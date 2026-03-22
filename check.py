with open('lib/presentation/ui/reader_page.dart', 'r', encoding='utf-8') as f:
    content = f.read()

idx = content.find('styleInjection')
if idx != -1:
    print(f"Chars before styleInjection:")
    for i in range(idx-3, idx):
        print(f"Char '{content[i]}' (ASCII: {ord(content[i])})")
