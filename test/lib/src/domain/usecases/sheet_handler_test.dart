// import 'dart:io';

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_handler.dart';
import 'package:test/test.dart';
import 'dart:developer';


void main() {
  group('Sheet Navigation:', () {
    test('retrieves a SheetNode at given coordinates', () {
      var sheetHandler = SheetHandler(Sheet(SheetInitializer()));
      final gotNode = sheetHandler.getNode(x: 2, y: 3);

      expect(gotNode.runtimeType, SheetNode);
    });
    test('does NOT retrieve a SheetNode at invalid coordinates', () {
      var sheetHandler = SheetHandler(Sheet(SheetInitializer()));

      expect(() => sheetHandler.getNode(x: 10, y: 3), throwsException);
    });
  });
  group('SheetNode Updates:', () {
    test('updates a SheetNode at given coordinates', () {
      var sheet = Sheet(SheetInitializer());
      var sheetHandler = SheetHandler(sheet);
      sheetHandler.updateSolutionsAt(x: 3, y: 5, newSolutions: {2,4,6});

      expect(sheetHandler.getNode(x: 3, y: 5).solutions, {2,4,6});
    });
    test('does NOT update a SheetNode at invalid coordinates', () {
      var sheet = Sheet(SheetInitializer());
      var sheetHandler = SheetHandler(sheet);

      expect(() => sheetHandler.updateSolutionsAt(x: 3, y: -3, newSolutions: {2,4,6}), throwsException);
    });
    test('removes a solution at given coordinates', () {
      var sheet = Sheet(SheetInitializer());
      var sheetHandler = SheetHandler(sheet);

      sheetHandler.removeSolutionAt(x: 5, y: 7, solution: 4);

      expect(sheetHandler.getNode(x: 5, y: 7).solutions, {1,2,3,5,6,7,8,9});
    });
    test('does NOT remove a solution at invalid coordinates', () {
      var sheet = Sheet(SheetInitializer());
      var sheetHandler = SheetHandler(sheet);

      expect(() => sheetHandler.removeSolutionAt(x: -3, y: 7, solution: 4), throwsException);
    });
  });
  group('Sheet rules:', () {
    test('evaluates sheet as solved', () {
      // create solved SheetNodes
      // init each SheetNode with a unique set of integers of length 1
      List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];

      for (var i = 1; i <= 9; i++) {
        for (var j = 1; j <= 9; j++) {
          sheetNodeData[i-1].add(SheetNode({Stub.solvedSheetData[i-1][j-1]}));
        }
      }

      inspect(sheetNodeData);

      var sheetInitializer = SheetInitializer(rowData: sheetNodeData);
      var sheet = Sheet(sheetInitializer);

      var sheetHandler = SheetHandler(sheet);

      expect(sheetHandler.isSolved(), true);
    });
    test('evaluates sheet as unsolved', () {
      var sheetInitializer = SheetInitializer();
      var sheet = Sheet(sheetInitializer);
      var sheetHandler = SheetHandler(sheet);

      expect(sheetHandler.isSolved(), false);
    });
    test('determines that sheet matches another sheet', () {
      var sheet1 = Sheet(SheetInitializer());
      var sheet2 = Sheet(SheetInitializer());
      var sheetHandler = SheetHandler(sheet1);

      expect(sheetHandler.sheetEquals(sheet2), true);
    });
    test('determines that sheet DOES NOT match another sheet', () {
      // create solved SheetNodes
      // init each SheetNode with a unique set of integers of length 1
      List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];

      for (var i = 1; i <= 9; i++) {
        for (var j = 1; j <= 9; j++) {
          sheetNodeData[i-1].add(SheetNode({Stub.solvedSheetData[i-1][j-1]}));
        }
      }

      inspect(sheetNodeData);

      var sheetInitializer = SheetInitializer(rowData: sheetNodeData);
      var sheet = Sheet(sheetInitializer);

      var sheetHandler = SheetHandler(sheet);

      var sheet2 = Sheet(SheetInitializer());

      expect(sheetHandler.sheetEquals(sheet2), false);
    });
  });
  group('Sheet Utilities:', () {
    test('clones a sheet (clone matches)', () {
      var sourceSheet = Sheet(SheetInitializer());
      var sheetHandler = SheetHandler(sourceSheet);
      var sheetClone = sheetHandler.clone();

      expect(sheetHandler.sheetEquals(sheetClone), true);
    });
    test('clones a sheet (clone is not identical)', () {
      var sourceSheet = Sheet(SheetInitializer());
      var sheetHandler = SheetHandler(sourceSheet);
      var sheetClone = sheetHandler.clone();

      expect(sourceSheet == sheetClone, false);
    });
  });
}

class Stub {
  static const solvedSheetData = [
    [1,8,4,2,3,6,5,7,9],
    [2,9,3,7,4,5,1,6,8],
    [6,7,5,9,8,1,4,2,3],
    [7,1,9,8,2,3,6,5,4],
    [4,2,8,6,5,7,3,9,1],
    [5,3,6,4,1,9,7,8,2],
    [3,4,7,5,9,8,2,1,6],
    [8,6,2,1,7,4,9,3,5],
    [9,5,1,3,6,2,8,4,7],
  ];
}
