// import 'dart:io';

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_solve_result.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_solver.dart';
import 'package:dart_sudoku/src/service/presenters/sheet_presenter.dart';
import 'package:test/test.dart';

const defaultSolutions = {1,2,3,4,5,6,7,8,9};

main() {
  group('Eliminate Solutions:', () {

    test('finds a solved node', () {
      // create a solved SheetNode
      List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];

      final solvedNode = SheetNode({3});
      final solvedNodeX = 5;
      final solvedNodeY = 3;

      final SolvedNodeElement solvedNodeElement = SolvedNodeElement(solvedNode, {'x': solvedNodeX, 'y': solvedNodeY});

      for (var i = 1; i <= 9; i++) {
        for (var j = 1; j <= 9; j++) {
          if (i == solvedNodeY && j == solvedNodeX) {
            // add a solved SheetNode
            sheetNodeData[i-1].add(solvedNode);
          } else {
            // add a default SheetNode
            sheetNodeData[i-1].add(SheetNode());
          }
        }
      }

      // create sheet with one solved node
      var sheetInitializer = SheetInitializer(rowData: sheetNodeData);
      var sheet = Sheet(sheetInitializer);

      var sheetSolver = SheetSolver(sheet);
      sheetSolver.findSolvedNodes();

      expect(sheetSolver.solvedNodes.length, 1);
      expect(sheetSolver.solvedNodes.first.equals(solvedNodeElement), true);
    });

    test('finds all solved nodes', () {
      // create solved SheetNodes
      // init each SheetNode with a unique set of integers of length 1
      List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];

      final solvedNode1 = SheetNode({3});
      final solvedNode1X = 5;
      final solvedNode1Y = 3;

      final SolvedNodeElement solvedNodeElement1 = SolvedNodeElement(solvedNode1, {'x': solvedNode1X, 'y': solvedNode1Y});

      final solvedNode2 = SheetNode({4});
      final solvedNode2X = 7;
      final solvedNode2Y = 1;

      final SolvedNodeElement solvedNodeElement2 = SolvedNodeElement(solvedNode2, {'x': solvedNode2X, 'y': solvedNode2Y});

      for (var i = 1; i <= 9; i++) {
        for (var j = 1; j <= 9; j++) {
          if (i == solvedNode1Y && j == solvedNode1X) {
            // add a solved SheetNode
            sheetNodeData[i-1].add(solvedNode1);
          } else if (i == solvedNode2Y && j == solvedNode2X) {
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

      expect(sheetSolver.solvedNodes.length, 2);
      expect(
          sheetSolver.solvedNodes.first.equals(solvedNodeElement1) ||
          sheetSolver.solvedNodes.first.equals(solvedNodeElement2), true);
      expect(
          sheetSolver.solvedNodes.last.equals(solvedNodeElement1) ||
          sheetSolver.solvedNodes.last.equals(solvedNodeElement2), true);
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

      // var sheetPresenter = SheetPresenter();
      // sheetPresenter.writeSheet(sheet);
      // sheetPresenter.printCanvas();

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

      // var sheetPresenter = SheetPresenter();
      // sheetPresenter.writeSheet(sheet);
      // sheetPresenter.printCanvas();

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

      // var sheetPresenter = SheetPresenter();
      // sheetPresenter.writeSheet(sheet);
      // sheetPresenter.printCanvas();

      // affected sector should have top left coordinate 4,4 (node array coordinate [3][3])
      // since solved node at 4,6 belongs to sector at 4,4
      for (var i = 3; i <= 5; i++) {
        for (var j = 3; j <= 5; j++) {
          if (j != (solvedNodeX - 1) || i != (solvedNodeY - 1)) {
            expect(sheet.rows[i][j].solutions, defaultMinusSolved);
          }
        }
      }
    });

    test('eliminate solutions in row, column, and sector', () {
      // create solved SheetNodes
      final solvedSet = {3};
      final defaultMinusSolved = defaultSolutions.difference(solvedSet);
      final solvedNodeX = 4;
      final solvedNodeY = 6;

      var sheet = createDummySheet(solvedSet, solvedNodeX, solvedNodeY);

      var sheetSolver = SheetSolver(sheet);

      sheetSolver.removeSolutions(solution: 3, exceptX: solvedNodeX, exceptY: solvedNodeY);
      // TODO: create a method or function to retrieve the solution from a solved node?
      //  OR just use node.solutions.last?

      // var sheetPresenter = SheetPresenter();
      // sheetPresenter.writeSheet(sheet);
      // sheetPresenter.printCanvas();

      // expect solution absent from row
      for (var i = 0; i < 9; i++) {
        if (i != solvedNodeX - 1) {
          expect(sheet.rows[solvedNodeY - 1][i].solutions, defaultMinusSolved);
        }
      }

      // expect solution absent from column
      for (var i = 0; i < 9; i++) {
        for (var j = 0; j < 9; j++) {
          if (j == solvedNodeX - 1 && i != solvedNodeY - 1) {
            expect(sheet.rows[i][j].solutions, defaultMinusSolved);
          }
        }
      }

      // expect solution absent from sector
      for (var i = 3; i <= 5; i++) {
        for (var j = 3; j <= 5; j++) {
          if (j != (solvedNodeX - 1) || i != (solvedNodeY - 1)) {
            expect(sheet.rows[i][j].solutions, defaultMinusSolved);
          }
        }
      }
    });
  });

  group('Evaluate Sheet:', () {
    test('stops if the sheet is solved', () async {
      var unsolvedSheet = createDummySheetFromData(Stub.solvableEasySheetData2);
      var sheetSolver = SheetSolver(unsolvedSheet);

      var result = await sheetSolver.solve(inputSheet: unsolvedSheet);

      expect(result.finalStatus, FinalStatus.solved);
    });

    test('halts if the sheet cannot be solved', () async {
      var unsolvedSheet = Sheet(SheetInitializer());
      var sheetSolver = SheetSolver(unsolvedSheet);

      var result = await sheetSolver.solve(inputSheet: unsolvedSheet);

      expect(result.finalStatus, FinalStatus.unsolvable);
    });

    test('solves an easy sheet', () async {
      var unsolvedSheet = createDummySheetFromData(Stub.solvableEasySheetData2);
      var sheetSolver = SheetSolver(unsolvedSheet);

      print('testing sheet:');
      var sheetPresenter = SheetPresenter();
      sheetPresenter.writeSheet(unsolvedSheet);
      print(sheetPresenter.canvas);

      var result = await sheetSolver.solve(inputSheet: unsolvedSheet);

      expect(result.finalStatus, FinalStatus.solved);
    });

    test('solves a medium sheet', () async {
      var unsolvedSheet = createDummySheetFromData(Stub.solvableMediumSheetData);
      var sheetSolver = SheetSolver(unsolvedSheet);

      print('testing sheet:');
      var sheetPresenter = SheetPresenter();
      sheetPresenter.writeSheet(unsolvedSheet);
      print(sheetPresenter.canvas);

      var result = await sheetSolver.solve(inputSheet: unsolvedSheet);

      expect(result.finalStatus, FinalStatus.solved);
    });

    test('solves a hard sheet', () async {
      // var unsolvedSheet = createDummySheetFromData(Stub.solvableHardSheetData);
      var unsolvedSheet = createDummySheetFromData(Stub.solvableHardSheetData2);
      var sheetSolver = SheetSolver(unsolvedSheet);

      print('testing sheet:');
      var sheetPresenter = SheetPresenter();
      sheetPresenter.writeSheet(unsolvedSheet);
      print(sheetPresenter.canvas);

      var result = await sheetSolver.solve(inputSheet: unsolvedSheet);

      expect(result.finalStatus, FinalStatus.solved);
    });

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

  group('Compares SolvedNodeElements', () {
    test('finds that two SolvedNodeElements are equal', () {
      final solvedNode1 = SheetNode({3});
      final solvedNode1X = 5;
      final solvedNode1Y = 3;

      final SolvedNodeElement solvedNodeElement1 = SolvedNodeElement(solvedNode1, {'x': solvedNode1X, 'y': solvedNode1Y});

      final solvedNode2 = SheetNode({3});
      final solvedNode2X = 5;
      final solvedNode2Y = 3;

      final SolvedNodeElement solvedNodeElement2 = SolvedNodeElement(solvedNode2, {'x': solvedNode2X, 'y': solvedNode2Y});

      expect(solvedNodeElement1.equals(solvedNodeElement2), true);
    });
    test('finds that two SolvedNodeElements with different coords are NOT equal', () {
      final solvedNode1 = SheetNode({3});
      final solvedNode1X = 5;
      final solvedNode1Y = 3;

      final SolvedNodeElement solvedNodeElement1 = SolvedNodeElement(solvedNode1, {'x': solvedNode1X, 'y': solvedNode1Y});

      final solvedNode2 = SheetNode({3});
      final solvedNode2X = 2;
      final solvedNode2Y = 9;

      final SolvedNodeElement solvedNodeElement2 = SolvedNodeElement(solvedNode2, {'x': solvedNode2X, 'y': solvedNode2Y});

      expect(solvedNodeElement1.equals(solvedNodeElement2), false);
    });
    test('finds that two SolvedNodeElements with different solutions are NOT equal', () {
      final solvedNode1 = SheetNode({3});
      final solvedNode1X = 5;
      final solvedNode1Y = 3;

      final SolvedNodeElement solvedNodeElement1 = SolvedNodeElement(solvedNode1, {'x': solvedNode1X, 'y': solvedNode1Y});

      final solvedNode2 = SheetNode({6});
      final solvedNode2X = 5;
      final solvedNode2Y = 3;

      final SolvedNodeElement solvedNodeElement2 = SolvedNodeElement(solvedNode2, {'x': solvedNode2X, 'y': solvedNode2Y});

      expect(solvedNodeElement1.equals(solvedNodeElement2), false);
    });
  });
}

Sheet createDummySheet([Set<int>? solvedSetArg, int? solvedSetXArg, int? solvedSetYArg]) {
  // create solved SheetNodes
  // init each SheetNode with a unique set of integers of length 1
  List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];

  // final solvedSet = solvedSetArg ?? {};
  // final defaultMinusSolved = defaultSolutions.difference(solvedSet);
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

Sheet createDummySheetFromData(List<List<int>> sheetSourceData) {
  List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];

  for (var i = 1; i <= 9; i++) {
    for (var j = 1; j <= 9; j++) {
      if (sheetSourceData[i-1][j-1] == 0) {
        sheetNodeData[i-1].add(SheetNode());
      } else {
        sheetNodeData[i-1].add(SheetNode({sheetSourceData[i-1][j-1]}));
      }
    }
  }

  var sheetInitializer = SheetInitializer(rowData: sheetNodeData);
  return Sheet(sheetInitializer);
}

class Stub {
  static const solvableEasySheetData = [
    [0,1,0,0,0,0,0,0,8],
    [6,0,0,1,0,0,4,0,9],
    [7,0,4,0,0,8,1,0,2],
    [0,9,7,0,0,0,2,0,4],
    [0,4,2,0,1,0,0,0,7],
    [0,0,8,4,0,0,0,1,0],
    [0,5,0,3,4,9,7,0,0],
    [0,0,3,0,5,6,8,9,0],
    [9,2,0,8,0,1,3,4,0],
  ];

  static const solvableEasySheetData2 = [
    [3,4,0,0,0,0,0,7,0],
    [8,0,0,4,0,7,2,5,0],
    [7,0,6,8,0,0,3,0,9],
    [0,1,3,0,0,6,4,0,0],
    [0,0,7,0,0,4,0,1,0],
    [0,0,4,0,0,0,6,0,3],
    [0,7,9,6,5,0,1,0,2],
    [0,0,0,7,0,0,5,9,8],
    [0,3,0,2,9,1,7,0,0],
  ];

  static const solvableMediumSheetData = [
    [0,0,9,3,1,0,5,2,0],
    [5,3,1,7,0,6,0,0,0],
    [0,2,7,4,0,0,0,0,0],
    [4,0,0,0,7,0,3,0,2],
    [0,0,0,8,0,0,0,0,6],
    [0,0,0,0,0,3,4,7,0],
    [0,0,0,0,5,0,0,0,0],
    [0,0,0,0,0,7,0,4,9],
    [0,7,4,0,0,0,6,0,1],
  ];

  static const solvableHardSheetData = [
    [5,6,0,0,0,0,0,2,7],
    [0,4,0,0,8,0,0,1,0],
    [1,9,0,0,5,4,0,0,0],
    [0,0,0,0,0,0,0,0,2],
    [2,1,0,0,0,0,0,0,0],
    [0,0,0,1,6,0,0,0,8],
    [9,0,0,3,0,0,0,7,0],
    [0,0,0,0,0,6,0,0,9],
    [0,7,0,0,0,0,0,5,6],
  ];

  static const solvableHardSheetData2 = [
    [8,0,6,0,0,0,4,0,9],
    [0,0,0,0,0,0,0,0,0],
    [0,9,2,0,0,0,5,0,8],
    [0,0,9,0,7,1,3,0,0],
    [5,0,8,0,0,0,0,2,0],
    [0,0,4,0,5,0,0,0,0],
    [0,0,0,0,0,7,9,1,0],
    [0,0,0,9,0,0,0,0,7],
    [0,7,0,0,0,3,0,0,4],
  ];
}
