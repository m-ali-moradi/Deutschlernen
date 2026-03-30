
import 'dart:io';

void main() {
  final dir = Directory('d:/Projects/Deutschlernen/assets/content/exercises');
  if (dir.existsSync()) {
    print('Contents of ${dir.path}:');
    dir.listSync().forEach((file) => print(file.path));
  } else {
    print('Directory not found: ${dir.path}');
  }
}
