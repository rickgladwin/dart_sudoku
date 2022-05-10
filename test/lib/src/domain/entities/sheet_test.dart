// unit tests for sheet entities

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:test/test.dart';
// import 'dart:io';

void main() {
  group('Sheet', () {
    group('Initializes with a 9x9 grid of SheetNodes', () {
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

    group('Is indexable by row and column to the SheetNode level', () {
      test('is indexable by row', () {
        var sheetInitializer = initializeFromPartialData(); // puts {6} at row 3, col 5
        var sheet = Sheet(sheetInitializer);
        expect(sheet.rows[2][4].solutions, equals({6}));
      });

      test('is indexable by column', () {
        var sheetInitializer = initializeFromPartialData(); // puts {2} at row 8 col 4
        var sheet = Sheet(sheetInitializer);
        expect(sheet.columns[3][7].solutions, equals({2}));
      });
    });
  });
  group('SheetInitializer', () {
    test('initializes with default values', () {
      var sheetInitializer = SheetInitializer();

      for (var i = 0; i < sheetInitializer.rows.length; i++) {
        for (var j = 0; j < sheetInitializer.rows[i].length; j++) {
          expect(sheetInitializer.rows[i][j].runtimeType, equals(SheetNode));
        }
      }
    });

    test('initializes with all data given', () {
      List<List<SheetNode?>> rowsData = [];
      for (var i = 0; i < 9; i++) {
        rowsData.add([]);
        for (var j = 0; j < 9; j++) {
          rowsData[i].add(SheetNode({j + 1}));
        }
      }

      var sheetInitializer = SheetInitializer(rowData: rowsData);

      for (var i = 0; i < sheetInitializer.rows.length; i++) {
        for (var j = 0; j < sheetInitializer.rows[i].length; j++) {
          var expectedValue = (j + 1);
          expect(sheetInitializer.rows[i][j].solutions, equals({expectedValue}));
        }
      }
    });

    test('initializes with partial data given', () {
      var sheetNodeRow3Col5 = {6};
      var sheetNodeRow8Col4 = {2};
      var sheetNodeDefault = {1,2,3,4,5,6,7,8,9};

      List<List<SheetNode?>> rowsData = [];
      for (var i = 0; i < 9; i++) {
        rowsData.add([]);
        for (var j = 0; j < 9; j++) {
          if (i == 2 && j == 4) {
            rowsData[i].add(SheetNode(sheetNodeRow3Col5));
            continue;
          }
          if (i == 7 && j == 3) {
            rowsData[i].add(SheetNode(sheetNodeRow8Col4));
            continue;
          }
          rowsData[i].add(null);
        }
      }

      // for (var i = 0; i < 9; i++) {
      //   print("rowsData row $i");
      //   for (var j = 0; j < 9; j++) {
      //     stdout.write("${rowsData[i][j]},");
      //   }
      //   print("");
      // }

      var sheetInitializer = SheetInitializer(rowData: rowsData);

      // for (var i = 0; i < 9; i++) {
      //   print("initializer row $i");
      //   for (var j = 0; j < 9; j++) {
      //     stdout.write("${sheetInitializer.rows[i][j]},");
      //   }
      //   print("");
      // }

      for (var i = 0; i < sheetInitializer.rows.length; i++) {
        for (var j = 0; j < sheetInitializer.rows[i].length; j++) {
          if (i == 2 && j == 4) {
            rowsData[i].add(SheetNode(sheetNodeRow3Col5));
            expect(sheetInitializer.rows[i][j].solutions, equals(sheetNodeRow3Col5));
            continue;
          }
          if (i == 7 && j == 3) {
            expect(sheetInitializer.rows[i][j].solutions, equals(sheetNodeRow8Col4));
            continue;
          }
          expect(sheetInitializer.rows[i][j].solutions, equals(sheetNodeDefault));
        }
      }
    });

  });
}

SheetInitializer initializeFromPartialData() {
  var sheetNodeRow3Col5 = {6};
  var sheetNodeRow8Col4 = {2};

  List<List<SheetNode?>> rowsData = [];
  for (var i = 0; i < 9; i++) {
    rowsData.add([]);
    for (var j = 0; j < 9; j++) {
      if (i == 2 && j == 4) {
        rowsData[i].add(SheetNode(sheetNodeRow3Col5));
        continue;
      }
      if (i == 7 && j == 3) {
        rowsData[i].add(SheetNode(sheetNodeRow8Col4));
        continue;
      }
      rowsData[i].add(null);
    }
  }

  var sheetInitializer = SheetInitializer(rowData: rowsData);

  return sheetInitializer;
}
