import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_solver.dart';
import 'package:test/test.dart';


main() {
  group('Eliminate Solutions:', () {

    test('finds a solved node', () {
      // create solved SheetNodes
      // init each SheetNode with a unique set of integers of length 1
      List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];

      final solvedNode = SheetNode({3});

      for (var i = 1; i <= 9; i++) {
        for (var j = 1; j <= 9; j++) {
          if (i == 5 && j == 3) {
            // add a solved SheetNode
            sheetNodeData[i-1].add(solvedNode);
          } else {
            // add a default SheetNode
            sheetNodeData[i-1].add(SheetNode());
          }
        }
      }

      var sheetInitializer = SheetInitializer(rowData: sheetNodeData);
      var sheet = Sheet(sheetInitializer);

      var sheetSolver = SheetSolver(sheet);
      sheetSolver.findSolvedNodes();

      expect(sheetSolver.solvedNodes, {solvedNode});
    });

    test('finds all solved nodes', () {
      // create solved SheetNodes
      // init each SheetNode with a unique set of integers of length 1
      List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];

      final solvedNode1 = SheetNode({3});
      final solvedNode2 = SheetNode({3});

      for (var i = 1; i <= 9; i++) {
        for (var j = 1; j <= 9; j++) {
          if (i == 5 && j == 3) {
            // add a solved SheetNode
            sheetNodeData[i-1].add(solvedNode1);
          } else if (i == 7 && j == 4) {
            // add another solved SheetNode
            sheetNodeData[i-1].add(solvedNode2);
          } else {
            // add a default SheetNode
            sheetNodeData[i-1].add(SheetNode());
          }
        }
      }

      var sheetInitializer = SheetInitializer(rowData: sheetNodeData);
      var sheet = Sheet(sheetInitializer);

      var sheetSolver = SheetSolver(sheet);
      sheetSolver.findSolvedNodes();

      expect(sheetSolver.solvedNodes, {solvedNode1, solvedNode2});
    });

    test('eliminates solutions across a row', () {

    }, skip: 'TODO: seek and remove solutions in the same row as a solved node');

    test('eliminate solutions in a column', () {

    }, skip: 'TODO: seek and remove solutions in the same column as a solved node');

    test('eliminate solutions in sector', () {

    }, skip: 'TODO: seek and remove solutions in the same sector as a solved node');
  });

  group('Evaluate Sheet:', () {
    test('stops if the sheet is solved', () {

    }, skip: 'TODO: stop if the sheet is solved (a higher abstract than checking in the handler)');

    test('halts if the sheet cannot be solved', () {

    }, skip: 'TODO: create halting logic/conditions');
  });
}

class Stub {
  /*

   */
}