import 'package:dart_sudoku/src/core/helpers.dart';
import 'package:test/test.dart';


main() {
  group('Helpers', () {
    test('gets file extension for files with only one dot', () {
      const filename = 'some_file.sdk';
      expect(getFileExtension(fileName: filename), 'sdk');
    });
    test('gets file extension for files with more than one dot', () {
      const filename = 'some_file.something.sdk';
      expect(getFileExtension(fileName: filename), 'sdk');
    });
    test('returns a nullish result for files with no extension', () {
      const filename = 'some_file';
      expect(getFileExtension(fileName: filename), '');
    });
  });
}