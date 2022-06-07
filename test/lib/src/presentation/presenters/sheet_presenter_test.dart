// unit tests etc. for sheet presenter

import 'dart:io';

import 'package:dart_sudoku/src/presentation/presenters/sheet_presenter.dart';
import 'package:test/test.dart';


// known good default sheet presenter output
// TODO: build using characters in src/config

void main() {
  group('SheetPresenter', () => {
    group('CLI', () {
      test('presents a default sheet', () {
        // const char = Char.tl2;
        // stdout.write('\nchar:');
        // stdout.write(char);
        printSheet();
      });
    })
  });
}
