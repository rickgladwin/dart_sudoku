// unit tests for sheet entities

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
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

        expect(sheet.rows.length, equals(9));
      }, skip: 'TODO: init columns');
      test('initializes with a grid of SheetNodes', () {}, skip: 'TODO: init SheetNodes');
    });
    test('initializes with arguments', () {}, skip: 'TODO: initialize a Sheet of SheetNodes from a dataset');
    test('is indexable by row and column to the SheetNode level', () {}, skip: 'TODO: ensure indexable Sheet data');
  });
}
