
import 'dart:convert';
import 'dart:io';

void main() {
  final files = [
    'd:/Projects/Deutschlernen/assets/content/exercises/a1.json',
    'd:/Projects/Deutschlernen/assets/content/exercises/a2.json',
  ];

  for (final filePath in files) {
    print('--- Topics in $filePath ---');
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        print('File not found: $filePath');
        continue;
      }
      final content = file.readAsStringSync();
      final List<dynamic> exercises = jsonDecode(content);
      final topics = exercises.map((e) => e['topic'] as String).toSet().toList()..sort();
      for (final topic in topics) {
        print(topic);
      }
    } catch (e) {
      print('Error reading $filePath: $e');
    }
  }
}
