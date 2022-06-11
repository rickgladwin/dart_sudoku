import 'dart:io';

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_solver.dart';
import 'package:dart_sudoku/src/presentation/presenters/sheet_presenter.dart';
import 'package:test/test.dart';

const defaultSolutions = {1,2,3,4,5,6,7,8,9};

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
      // create solved SheetNodes
      final solvedSet = {3};
      final defaultMinusSolved = defaultSolutions.difference(solvedSet);
      final solvedNodeX = 4;
      final solvedNodeY = 6;

      var sheet = createDummySheet(solvedSet, solvedNodeX, solvedNodeY);

      var sheetSolver = SheetSolver(sheet);

      sheetSolver.removeSolutionsFromRow(solution: 3, exceptX: solvedNodeX, exceptY: solvedNodeY);

      var sheetPresenter = SheetPresenter();
      sheetPresenter.writeSheet(sheet);
      sheetPresenter.printCanvas();

      sleep(Duration(seconds: 1));

      for (var i = 0; i < 9; i++) {
        if (i != solvedNodeX - 1) {
          expect(sheet.rows[solvedNodeY - 1][i].solutions, defaultMinusSolved);
        }
      }
    });

    test('eliminate solutions in a column', () {
      // create solved SheetNodes
      final solvedSet = {3};
      final defaultMinusSolved = defaultSolutions.difference(solvedSet);
      final solvedNodeX = 4;
      final solvedNodeY = 6;

      var sheet = createDummySheet(solvedSet, solvedNodeX, solvedNodeY);

      var sheetSolver = SheetSolver(sheet);

      sheetSolver.removeSolutionsFromCol(solution: 3, exceptX: solvedNodeX, exceptY: solvedNodeY);

      var sheetPresenter = SheetPresenter();
      sheetPresenter.writeSheet(sheet);
      sheetPresenter.printCanvas();

      for (var i = 0; i < 9; i++) {
        for (var j = 0; j < 9; j++) {
          if (j == solvedNodeX - 1 && i != solvedNodeY - 1) {
            expect(sheet.rows[i][j].solutions, defaultMinusSolved);
          }
        }
      }
    });

    test('eliminate solutions in sector', () {
      // create solved SheetNodes
      final solvedSet = {3};
      final defaultMinusSolved = defaultSolutions.difference(solvedSet);
      final solvedNodeX = 4;
      final solvedNodeY = 6;

      var sheet = createDummySheet(solvedSet, solvedNodeX, solvedNodeY);

      var sheetSolver = SheetSolver(sheet);

      sheetSolver.removeSolutionsFromSector(solution: 3, nodeX: solvedNodeX, nodeY: solvedNodeY);

      var sheetPresenter = SheetPresenter();
      sheetPresenter.writeSheet(sheet);
      sheetPresenter.printCanvas();

      // affected sector should have top left coordinate 4,4 (node array coordinate [3][3])
      // since solved node at 4,6 belongs to sector at 2,2
      for (var i = 3; i <= 5; i++) {
        for (var j = 3; j <= 5; j++) {
          if (j != (solvedNodeX - 1) && i != (solvedNodeY - 1)) {
            expect(sheet.rows[i][j].solutions, defaultMinusSolved);
          }
        }
      }
    });

    test('eliminate solutions in row, column, and sector', () {

    }, skip: 'TODO: eliminate ineligible solutions in all directions');
  });

  group('Evaluate Sheet:', () {
    test('stops if the sheet is solved', () {

    }, skip: 'TODO: stop if the sheet is solved (a higher abstract than checking in the handler)');

    test('halts if the sheet cannot be solved', () {

    }, skip: 'TODO: create halting logic/conditions');
  });

  group('Find Sector Coordinates:', () {
    test('finds 1,1 from 2,3', () {
      expect(sectorCoordFromNodeCoord(nodeX: 2, nodeY: 3), {'x': 1, 'y': 1});
    });
    test('finds 4,1 from 6,2', () {
      expect(sectorCoordFromNodeCoord(nodeX: 6, nodeY: 2), {'x': 4, 'y': 1});
    });
    test('finds 7,7 from 8,9', () {
      expect(sectorCoordFromNodeCoord(nodeX: 8, nodeY: 9), {'x': 7, 'y': 7});
    });
    test('finds 4,4 from 4,6', () {
      expect(sectorCoordFromNodeCoord(nodeX: 4, nodeY: 6), {'x': 4, 'y': 4});
    });
  });
}

Sheet createDummySheet([Set<int>? solvedSetArg, int? solvedSetXArg, int? solvedSetYArg]) {
  // create solved SheetNodes
  // init each SheetNode with a unique set of integers of length 1
  List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];

  final solvedSet = solvedSetArg ?? {};
  final defaultMinusSolved = defaultSolutions.difference(solvedSet);
  final solvedNode = (solvedSetArg != null) ? SheetNode(solvedSetArg) : SheetNode();
  final solvedNodeX = solvedSetXArg;
  final solvedNodeY = solvedSetYArg;

  for (var i = 1; i <= 9; i++) {
    for (var j = 1; j <= 9; j++) {
      if (i == solvedNodeY && j == solvedNodeX) {
        // add a solved SheetNode
        sheetNodeData[i - 1].add(solvedNode);
      } else {
        // add a default SheetNode
        sheetNodeData[i-1].add(SheetNode());
      }
    }
  }

  var sheetInitializer = SheetInitializer(rowData: sheetNodeData);
  return Sheet(sheetInitializer);
}

class Stub {
  /*

   */
}