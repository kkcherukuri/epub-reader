with open('lib/presentation/ui/reader_page.dart', 'r', encoding='utf-8') as f:
    content = f.read()

idx = 0
while True:
    idx = content.find('styleInjection', idx)
    if idx == -1: break
    print(f"Match at {idx}: Chars before: '{content[idx-3:idx]}', Ascii of last: {ord(content[idx-1])}")
    idx += 1
