import 'package:lines_longer_than_80_fix/lines_longer_than_80_fix.dart'
    as lines_longer_than_80_fix;
import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('path', abbr: 'p', help: 'The path to the project directory');

  final argResults = parser.parse(arguments);
  final directoryPath = argResults['path'];

  if (directoryPath == null) {
    print('Please provide a directory path using the --path option.');
    exit(1);
  }

  final directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    print('The provided directory does not exist.');
    exit(1);
  }

  // Process all Dart files in the directory
  directory.listSync(recursive: true).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      lines_longer_than_80_fix.processFile(entity);
    }
  });
}
