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

    }, skip: 'TODO: seek and remove solutions in the same sector as a solved node');

    test('eliminate solutions in row, column, and sector', () {

    }, skip: 'TODO: eliminate ineligible solutions in all directions');
  });

  group('Evaluate Sheet:', () {
    test('stops if the sheet is solved', () {

    }, skip: 'TODO: stop if the sheet is solved (a higher abstract than checking in the handler)');

    test('halts if the sheet cannot be solved', () {

    }, skip: 'TODO: create halting logic/conditions');
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