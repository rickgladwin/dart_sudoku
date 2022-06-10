// unit tests etc. for sheet presenter

import 'dart:io';

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/presentation/presenters/sheet_presenter.dart';
import 'package:test/test.dart';


// known good default sheet presenter output
// TODO: build known good
class KnownGood {
  // 123
  // 456
  // 789
  static const defaultSheet = [27, 91, 49, 59, 49, 72, 49, 50, 51, 27, 91, 50, 59, 49, 72, 52, 53, 54, 27, 91, 51, 59, 49, 72, 55, 56, 57, 27, 91, 52, 59, 49, 72];
}

void main() {
  group('SheetPresenter:', () => {
    group('isLineRow', () {
      test('identifies every 4th row as a line row', () {
        expect(isLineRow(4), true);
        expect(isLineRow(16), true);
        expect(isLineRow(40), true);
      });
      test('identifies non-4th rows as a non-line rows', () {
        expect(isLineRow(5), false);
        expect(isLineRow(17), false);
        expect(isLineRow(43), false);
      });
    }),
    group('isLineCol', () {
      test('identifies every 4th col as a line col', () {
        expect(isLineCol(4), true);
        expect(isLineCol(16), true);
        expect(isLineCol(40), true);
      });
      test('identifies non-4th rows as a non-line rows', () {
        expect(isLineCol(5), false);
        expect(isLineCol(17), false);
        expect(isLineCol(43), false);
      });
    }),
    group('isSectorBorderRow', () {
      test('identifies every 12th row as a sector border row', () {
        expect(isSectorBorderRow(12), true);
        expect(isLineRow(24), true);
        expect(isSectorBorderRow(36), true);
      });
      test('identifies non-12th rows as a non-sector border rows', () {
        expect(isSectorBorderRow(4), false);
        expect(isSectorBorderRow(13), false);
        expect(isSectorBorderRow(32), false);
      });
    }),
    group('isSectorBorderCol', () {
      test('identifies every 12th col as a sector border col', () {
        expect(isSectorBorderCol(12), true);
        expect(isLineCol(24), true);
        expect(isSectorBorderCol(36), true);
      });
      test('identifies non-12th cols as a non-sector border cols', () {
        expect(isSectorBorderCol(4), false);
        expect(isSectorBorderCol(13), false);
        expect(isSectorBorderCol(32), false);
      });
    }),
    group('CLI', () {
      test('presents a default sheet', () {
        var sheetInitializer = SheetInitializer();
        var sheet = Sheet(sheetInitializer);

        printSheet(sheet);
      }, skip: 'create "known good" printed sheet checker');
    })
  });
}
