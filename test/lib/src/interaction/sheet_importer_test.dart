import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/service/presenters/sheet_presenter.dart';
import 'package:test/test.dart';
import 'package:dart_sudoku/src/interaction/sheet_importer.dart';

import '../../../test_utilities/comparisons.dart';
import '../../../test_utilities/factories.dart';


main() {
  group('Validate:', () {
    test('accepts valid sdk import data', () {
      var sheetFile = 'sudoku_easy_1.sdk';
      var validationResult = SheetImporter().validate(dataFile: sheetFile);

      expect(validationResult.status, true);
    });

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
    test('imports data from sdk file', () async {
      const fileName = 'sudoku_easy_1.sdk';
      var sheetImporter = SheetImporter();
      await sheetImporter.importFileContent(fileName: fileName);

      expect(sheetImporter.puzzleData, validEasySDKData);
    });
    test('cleans sdk file data missing elements', () {
      var sheetImporter = SheetImporter();
      sheetImporter.puzzleData = validEasySDKData;
      sheetImporter.cleanSDKFileData(sdkFileData: validEasySDKData);
      expect(sheetImporter.puzzleData, cleanValidEasySDKData);
    });
    test('builds sheet data from a dummy sdk file', () {
      var blankSheet = Sheet(SheetInitializer());
      var sheetImporter = SheetImporter();

      var sheet = sheetImporter.buildSheet(puzzleData: cleanDummySDKData);

      var canvas = StringBuffer();
      var sheetPresenter = SheetPresenter(canvas);
      sheetPresenter.writeSheet(sheet);
      print(sheetPresenter.canvas);

      var canvas2 = StringBuffer();
      var sheetPresenter2 = SheetPresenter(canvas2);
      sheetPresenter2.writeSheet(sheet);
      print(sheetPresenter2.canvas);

      expect(sheetEqual(sheet1: sheet, sheet2: blankSheet), true);
    });
    test('builds sheet data from a sample sdk file', () {
      var dummySheet = createDummySheet({3}, 4, 6);
      var sheetImporter = SheetImporter();

      var sheet = sheetImporter.buildSheet(puzzleData: cleanSimpleSDKData);

      var canvas = StringBuffer();
      var sheetPresenter = SheetPresenter(canvas);
      sheetPresenter.writeSheet(sheet);
      print(sheetPresenter.canvas);

      var canvas2 = StringBuffer();
      var sheetPresenter2 = SheetPresenter(canvas2);
      sheetPresenter2.writeSheet(sheet);
      print(sheetPresenter2.canvas);

      expect(sheetEqual(sheet1: sheet, sheet2: dummySheet), true);
    });
    test('imports a sheet', () {
      var dataFile = 'sudoku_easy_1.sdk';
      Sheet importedSheet = SheetImporter().importToSheet(fileName: dataFile);

    });
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

const validEasySDKData = '''
[Puzzle]
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

const dummySDKData = '''
[Puzzle]
.........
.........
.........
.........
.........
.........
.........
.........
.........
''';

const cleanDummySDKData = '''
.........
.........
.........
.........
.........
.........
.........
.........
.........
''';

const cleanValidEasySDKData = '''
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

const cleanSimpleSDKData = '''
.........
.........
.........
.........
.........
...3.....
.........
.........
.........
''';
