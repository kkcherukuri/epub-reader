with open('lib/presentation/ui/reader_page.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if '\\\$' in line or r'\$' in line:
        print(f"Line {i+1}: {line.strip()}")
