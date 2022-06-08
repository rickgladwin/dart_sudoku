// unit tests etc. for sheet presenter

import 'dart:io';

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/presentation/presenters/sheet_presenter.dart';
import 'package:test/test.dart';


// known good default sheet presenter output
// TODO: build using characters in src/config

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
    group('CLI', () {
      test('presents a default sheet', () {
        // const char = Char.tl2;
        // stdout.write('\nchar:');
        // stdout.write(char);
        var sheetInitializer = SheetInitializer();
        var sheet = Sheet(sheetInitializer);

        printSheet(sheet);
      });
    })
  });
}
