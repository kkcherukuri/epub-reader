with open('lib/presentation/ui/reader_page.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace(r'\$', '$')

with open('lib/presentation/ui/reader_page.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Fix applied successfully to reader_page.dart")
