// unit tests for sheet entities

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:test/test.dart';

void main() {
  group('Sheet', () {
    group('initializes with a 9x9 grid of SheetNodes', () {
      test('initializes with 9 rows', () {
        var sheetInitializer = SheetInitializer();
        var sheet = Sheet(sheetInitializer);

        expect(sheet.rows.length, equals(9));
      });

      test('initializes with 9 columns', () {
        var sheetInitializer = SheetInitializer();
        var sheet = Sheet(sheetInitializer);

        expect(sheet.columns.length, equals(9));
      });

      test('initializes with a grid of SheetNodes', () {
        var sheetInitializer = SheetInitializer();
        var sheet = Sheet(sheetInitializer);

        for (var i = 0; i < sheet.rows.length; i++) {
          for (var j = 0; j < sheet.rows[i].length; j++) {
            expect(sheet.rows[i][j].runtimeType, equals(SheetNode));
          }
        }
      });

    });
    test('initializes with arguments', () {}, skip: 'TODO: initialize a Sheet of SheetNodes from a dataset');
    test('is indexable by row and column to the SheetNode level', () {}, skip: 'TODO: ensure indexable Sheet data');
  });
  group('SheetInitializer', () {
    test('initializes with default values', () {}, skip: 'TODO: test default init');
    test('initializes with partial data given', () {}, skip: 'TODO: test partial data init');
  });
}
