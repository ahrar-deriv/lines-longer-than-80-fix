import 'dart:io';

void processFile(File file) {
  final lines = file.readAsLinesSync();
  final newLines = <String>[];

  for (var line in lines) {
    if ((line.trim().startsWith('//') || line.trim().startsWith('///')) &&
        line.length > 80) {
      newLines.addAll(splitComment(line));
    } else {
      newLines.add(line);
    }
  }

  file.writeAsStringSync(newLines.join('\n'));
}

List<String> splitComment(String comment) {
  final splitLines = <String>[];
  const maxLength = 80;
  final words = comment.split(' ');
  var currentLine = '';
  final isDocComment = comment.trim().startsWith('///');
  final commentPrefix = isDocComment ? '/// ' : '// ';

  // Process words to split into lines with the maximum length limit
  for (var word in words) {
    if (currentLine.length + word.length + (currentLine.isEmpty ? 0 : 1) <=
        maxLength - commentPrefix.length) {
      if (currentLine.isEmpty) {
        currentLine = word;
      } else {
        currentLine += ' $word';
      }
    } else {
      splitLines.add(currentLine.trim());
      currentLine = word;
    }
  }

  // Add the last line
  if (currentLine.isNotEmpty) {
    splitLines.add(currentLine.trim());
  }

  // Ensure each subsequent line starts with the comment prefix
  for (var i = 1; i < splitLines.length; i++) {
    splitLines[i] = commentPrefix + splitLines[i];
  }
  return splitLines;
}
