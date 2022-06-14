// the main logic for solving sudoku puzzles

// import 'dart:io';

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_solve_result.dart';
// import 'package:dart_sudoku/src/domain/usecases/sheet_handler.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_node_handler.dart';
import 'package:collection/collection.dart';
// import 'package:dart_sudoku/src/service/presenters/sheet_presenter.dart';


class SheetSolver {
  late Sheet sheet;
  Set<SolvedNodeElement> solvedNodes = {};

  SheetSolver(this.sheet);

  void findSolvedNodes() {
    solvedNodes.clear();
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        var sheetNode = sheet.rows[i][j];
        if (SheetNodeHandler(sheetNode).isSolved()) {
          // print('SOLVED sheetNode.solutions: ${sheetNode.solutions}');
          var solvedNodeElement = SolvedNodeElement(sheetNode, {'x': j + 1, 'y': i + 1});
            solvedNodes.add(solvedNodeElement);
        }
      }
    }
  }

  void removeSolutionsFromRow({required int solution, required int exceptX, required int exceptY}) {
    for (var i = 0; i < 9; i++) {
      if (i != exceptX - 1) {
        SheetNodeHandler(sheet.rows[exceptY - 1][i]).removeSolution(solution);
      }
    }
  }

  void removeSolutionsFromCol({required int solution, required int exceptX, required int exceptY}) {
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        if (j == exceptX - 1 && i != exceptY - 1) {
          SheetNodeHandler(sheet.rows[i][j]).removeSolution(solution);
        }
      }
    }
  }

  void removeSolutionsFromSector({required int solution, required int nodeX, required int nodeY}) {
    final Map<String, int> sectorTopLeft = sectorCoordFromNodeCoord(nodeX: nodeX, nodeY: nodeY);
    final int sectorX = sectorTopLeft['x'] as int;
    final int sectorY = sectorTopLeft['y'] as int;

    // print(sectorTopLeft);

    for (var i = sectorY - 1; i < sectorY + 2; i++) {
      for (var j = sectorX - 1; j < sectorX + 2; j++) {
        if (i != (nodeY - 1) || j != (nodeX - 1)) {
          SheetNodeHandler(sheet.rows[i][j]).removeSolution(solution);
        }
      }
    }
  }

  void removeSolutions({required int solution, required int exceptX, required int exceptY}) {
    removeSolutionsFromRow(solution: solution, exceptX: exceptX, exceptY: exceptY);
    removeSolutionsFromCol(solution: solution, exceptX: exceptX, exceptY: exceptY);
    removeSolutionsFromSector(solution: solution, nodeX: exceptX, nodeY: exceptY);
  }

  Future<SheetSolveResult> solve({required Sheet inputSheet}) async {
    sheet = inputSheet;
    var result = SheetSolveResult();
    result.finalStatus = FinalStatus.unsolved;

    // var sheetPresenter = SheetPresenter();
    // sheetPresenter.writeSheet(sheet);
    // print('%% solving sheet:');
    // print(sheetPresenter.canvas);

    // for (var solvedNodeElement in solvedNodes) {
    //   print('** before: ${solvedNodeElement.solvedNode.solutions}');
    // }

    // update solvedNodes set
    findSolvedNodes();

    // print('BEFORE solvedNodes.length: ${solvedNodes.length}');

    // for (var solvedNodeElement in solvedNodes) {
    //   print('** after: ${solvedNodeElement.solvedNode.solutions}');
    // }

    //  if there are no solved nodes, return unsolvable
    if (solvedNodes.isEmpty) {
      result.finalStatus = FinalStatus.unsolvable;
      result.finalSheet = inputSheet;
      return result;
    }

    // Sheet sheetBefore = sheet;
    // late Sheet sheetAfter;

    // var sheetHandler = SheetHandler(sheet);

    int solvedNodesCountBefore;
    int solvedNodesCountAfter;

    // var rounds = 0;

    // loop until no updates:
    do {
      // findSolvedNodes();

      // remember solutions count before updates
      solvedNodesCountBefore = solvedNodes.length;

      // print('-- solvedNodesCountBefore: $solvedNodesCountBefore');

      // print('solvedNodes: $solvedNodes');
      // print('solvedNodes.first: ${solvedNodes.first}');
      // print('solvedNodes.first.solvedNode.solutions: ${solvedNodes.first.solvedNode.solutions}');

      // for (var solvedNodeElement in solvedNodes) {
      //   print('** ${solvedNodeElement.solvedNode.solutions}');
      // }

      for (var solvedNodeElement in solvedNodes) {
        // print('@ removing for ${solvedNodeElement.solvedNode.solutions.first} at ${solvedNodeElement.solvedNodeCoords['x']}, ${solvedNodeElement.solvedNodeCoords['y']}');
        removeSolutions(
            solution: solvedNodeElement.solvedNode.solutions.first,
            exceptX: solvedNodeElement.solvedNodeCoords['x'] as int,
            exceptY: solvedNodeElement.solvedNodeCoords['y'] as int
        );
      }
      // sleep(Duration(milliseconds: 600));

      findSolvedNodes();

      solvedNodesCountAfter = solvedNodes.length;
      // print('-- solvedNodesCountAfter: $solvedNodesCountAfter');

      // var sheetPresenter = SheetPresenter();
      // sheetPresenter.writeSheet(sheet);
      // print('*** sheetBefore canvas ***');
      // print(sheetPresenter.canvas);

      // sheetHandler.sheet = sheet;

      // ++rounds;

      // print('&&& solvedNodesCountBefore vs solvedNodesCountAfter: $solvedNodesCountBefore vs $solvedNodesCountAfter');
      // print('&&& solvedNodesCountBefore != solvedNodesCountAfter: ${solvedNodesCountBefore != solvedNodesCountAfter}');
      // print('&&& total rounds: $rounds');


      // removeSolutions should update sheetSolver.sheet (same sheet as sheetHandler.sheet)
    // } while (!sheetHandler.sheetEquals(sheetBefore));
    } while (solvedNodesCountBefore != solvedNodesCountAfter);

    //  reset updates this loop
    //  for each solved node
    //    remove competing solutions
    // if sheet is solved, return solved
    // else return unsolvable


    if (solvedNodes.length == 81) {
      result.finalStatus = FinalStatus.solved;
    } else {
      result.finalStatus = FinalStatus.unsolvable;
    }

    result.finalSheet = sheet;

    return result;
  }
}

class SolvedNodeElement {
  late final SheetNode solvedNode;
  late final Map<String, int> solvedNodeCoords;

  SolvedNodeElement(this.solvedNode, this.solvedNodeCoords);

  bool equals (SolvedNodeElement other) {
    // equal if solutions and coordinates match
    Function mapEquals = const MapEquality().equals;
    Function setEquals = const SetEquality().equals;

    if (!setEquals(solvedNode.solutions, other.solvedNode.solutions)) {
      return false;
    }
    if (!mapEquals(solvedNodeCoords, other.solvedNodeCoords)) {
      return false;
    }

    return true;
  }
}

/// Returns the coordinates of the top left node in the sector to which the
/// given node belongs. A sector is a block of 3x3 nodes. A sheet is 9x9 nodes,
/// or 3x3 sectors.
Map<String, int> sectorCoordFromNodeCoord ({required int nodeX, required int nodeY}) {
  int sectorX = ((nodeX - 1) / 3).floor() * 3 + 1;
  int sectorY = ((nodeY - 1) / 3).floor() * 3 + 1;

  return {
    'x': sectorX,
    'y': sectorY,
  };
}

Future<void> main() async {
  // create solved SheetNodes
  // init each SheetNode with a unique set of integers of length 1
  List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];

  for (var i = 1; i <= 9; i++) {
    for (var j = 1; j <= 9; j++) {
      if (Stub.solvableSheetData[i-1][j-1] == 0) {
        sheetNodeData[i-1].add(SheetNode());
      } else {
        sheetNodeData[i-1].add(SheetNode({Stub.solvableSheetData[i-1][j-1]}));
      }
    }
  }

  var sheetInitializer = SheetInitializer(rowData: sheetNodeData);
  var unsolvedSheet = Sheet(sheetInitializer);
  var sheetSolver = SheetSolver(unsolvedSheet);
  // sheetSolver.findSolvedNodes();

  var result = await sheetSolver.solve(inputSheet: unsolvedSheet);
}

class Stub {
  // 38 solved nodes
  static const solvableSheetData = [
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

  // 38 solved nodes
  static const solvableSheetData2 = [
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
}

