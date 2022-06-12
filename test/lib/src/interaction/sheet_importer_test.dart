import 'package:test/test.dart';
import 'package:dart_sudoku/src/interaction/sheet_importer.dart';


main() {
  group('Validate:', () {
    test('accepts valid sdk import data', () {
      var sheet_file = 'sudoku_easy_1.sdk';
      // var validation_result = SheetImporter.validate(sheet_file);

      // expect(validation_result.status, true);
    }, skip: 'TODO: build sheet data import validator');
    group('Rejects Invalid Data:', () {
      test('invalidates sdk data missing header', () {

      }, skip: 'TODO: make validator check for header');
      test('invalidates sdk data missing elements', () {

      }, skip: 'TODO: make validator count elements');
      test('rejects files without sdk extension', () {

      }, skip: 'TODO: make validator check file extension');
    });
  });
  group('Import:', () {
    test('imports data from sdk file', () {

    }, skip: 'TODO: build sdk data importer');
  });
}

var sdkDataMissingCharacters = '''[Puzzle]
.1......
6..1..4.9
7.4..81.
.97...2.4
.42.1...7
..84...1.
.5.3497..
..3.5689.
92.8.134.
''';

const validEasySDKData = '''[Puzzle]
.1......8
6..1..4.9
7.4..81.2
.97...2.4
.42.1...7
..84...1.
.5.3497..
..3.5689.
92.8.134.
''';