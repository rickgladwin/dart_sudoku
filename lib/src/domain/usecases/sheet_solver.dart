// the main logic for solving sudoku puzzles

// import 'dart:io';

import 'dart:io';

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_solve_result.dart';
// import 'package:dart_sudoku/src/domain/usecases/sheet_handler.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_node_handler.dart';
import 'package:collection/collection.dart';
import 'package:dart_sudoku/src/service/presenters/sheet_presenter.dart';
// import 'package:dart_sudoku/src/service/presenters/sheet_presenter.dart';


class SheetSolver {
  late Sheet sheet;
  Set<SolvedNodeElement> solvedNodes = {};
  // TODO: make a "quick hash" string or list that will represent a state for the sheet
  //  that is unique. Needs to be quickly buildable and also comparable to other versions of itself.
  StringBuffer quickHash = StringBuffer();

  SheetSolver(this.sheet);

  void updateSolvedNodesAndQuickHash() {
    solvedNodes.clear();
    quickHash.clear();
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        var sheetNode = sheet.rows[i][j];
        // update quickHash
        for (var element in sheetNode.solutions) {quickHash.write(element);}
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

  void promoteSolutionsInRow({required int row}) {
    for (var value = 1; value <= 9; value++) {
      List colsWithValue = [];
      for (var col = 0; col < 9; col++) {
        // check all (unsolved?) columns for value
        // record col if value found
        if (sheet.rows[row][col].solutions.contains(value)) {
          colsWithValue.add(col);
        }
      }
      // if value found in only one col
      //  set that node's solution set to value
      if (colsWithValue.length == 1) {
        sheet.rows[row][colsWithValue.first].solutions = {value};
      }
    }
  }

  void promoteSolutionsInCol({required int col}) {
    for (var value = 1; value <= 9; value++) {
      List rowsWithValue = [];
      for (var row = 0; row < 9; row++) {
        // check all rows for value
        // record row if value found
        if (sheet.rows[row][col].solutions.contains(value)) {
          rowsWithValue.add(row);
        }
      }
      // if value found in only one col
      //  set that node's solution set to value
      if (rowsWithValue.length == 1) {
        sheet.rows[rowsWithValue.first][col].solutions = {value};
      }
    }
  }

  void promoteSolutionsInSector({required int sectorRow, required int sectorCol}) {
    for (var value = 1; value <= 9; value++) {
      List rowsWithValue = [];
      List colsWithValue = [];

      for (var i = sectorRow; i < sectorRow + 3; i++) {
        for (var j = sectorCol; j < sectorCol + 3; j++) {
          if (sheet.rows[i][j].solutions.contains(value)) {
            rowsWithValue.add(i);
            colsWithValue.add(j);
          }
        }
      }

      if (rowsWithValue.length == 1) {
        sheet.rows[rowsWithValue.first][colsWithValue.first].solutions = {value};
      }
    }
  }

  void promoteSolutions() {
    // promote solutions in all rows
    for (var i = 0; i < 9; i++) {
      promoteSolutionsInRow(row: i);
    }
    // promote solutions in all columns
    for (var j = 0; j < 9; j++) {
      promoteSolutionsInCol(col: j);
    }
    // promote solutions in all sectors
    for (var i = 0; i < 9; i += 3) {
      for (var j = 0; j < 9; j += 3) {
        promoteSolutionsInSector(sectorRow: i, sectorCol: j);
      }
    }
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

    // update solvedNodes and quickHash set
    updateSolvedNodesAndQuickHash();

    // print('\nquickHash init:');
    // print(quickHash);

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
    String quickHashBefore;
    String quickHashAfter;

    var rounds = 0;

    var sheetPresenter = SheetPresenter();


    // loop until no updates:
    do {
      // findSolvedNodes();
      // update solvedNodes and quickHash set
      updateSolvedNodesAndQuickHash();

      // remember solutions count before updates
      solvedNodesCountBefore = solvedNodes.length;
      quickHashBefore = quickHash.toString();

      // print('\nquickHash before:');
      // print(quickHash);



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

      // updateSolvedNodesAndQuickHash();
      // quickHashAfter = quickHash.toString();

      sleep(Duration(milliseconds: 200));

      // sheetPresenter.writeSheet(sheet);
      // print('*** sheet after remove ***');
      // print(sheetPresenter.canvas);

      // print('%%% quickHashBefore: $quickHashBefore');
      // print('%%%  quickHashAfter: $quickHashAfter');
      // print('%%% quickHashBefore != quickHashAfter: ${quickHashBefore != quickHashAfter}');
      // print('&&& total rounds: $rounds');


      promoteSolutions();

      sleep(Duration(milliseconds: 200));

      updateSolvedNodesAndQuickHash();

      // print('\nquickHash after:');
      // print(quickHash);

      solvedNodesCountAfter = solvedNodes.length;
      quickHashAfter = quickHash.toString();
      // print('-- solvedNodesCountAfter: $solvedNodesCountAfter');

      // var sheetPresenter = SheetPresenter();
      sheetPresenter.writeSheet(sheet);
      print('*** sheet after round ***');
      print(sheetPresenter.canvas);

      print('%%% quickHashBefore: $quickHashBefore');
      print('%%%  quickHashAfter: $quickHashAfter');
      // print('%%% quickHashBefore != quickHashAfter: ${quickHashBefore != quickHashAfter}');
      print('&&& total rounds: $rounds');

      // sheetHandler.sheet = sheet;

      ++rounds;

      print('&&& solvedNodesCountBefore vs solvedNodesCountAfter: $solvedNodesCountBefore vs $solvedNodesCountAfter');
      print('&&& solvedNodesCountBefore != solvedNodesCountAfter: ${solvedNodesCountBefore != solvedNodesCountAfter}');

      // print('%%% quickHashBefore: $quickHashBefore');
      // print('%%%  quickHashAfter: $quickHashAfter');
      print('%%% quickHashBefore != quickHashAfter: ${quickHashBefore != quickHashAfter}');
      // print('&&& total rounds: $rounds');


      // removeSolutions should update sheetSolver.sheet (same sheet as sheetHandler.sheet)
    // } while (!sheetHandler.sheetEquals(sheetBefore));

      // TODO: get do loop exit comparison working
    } while (quickHashBefore != quickHashAfter);
    // } while (rounds < 10);

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
  // create unsolved Sheet
  var unsolvedSheet = createDummySheetFromData(Stub.solvableHardSheetData);

  // // init each SheetNode with a unique set of integers of length 1
  // List<List<SheetNode>> sheetNodeData = [[],[],[],[],[],[],[],[],[]];
  //
  // for (var i = 1; i <= 9; i++) {
  //   for (var j = 1; j <= 9; j++) {
  //     if (Stub.solvableSheetData[i-1][j-1] == 0) {
  //       sheetNodeData[i-1].add(SheetNode());
  //     } else {
  //       sheetNodeData[i-1].add(SheetNode({Stub.solvableSheetData[i-1][j-1]}));
  //     }
  //   }
  // }
  //
  // var sheetInitializer = SheetInitializer(rowData: sheetNodeData);
  // var unsolvedSheet = Sheet(sheetInitializer);
  var sheetSolver = SheetSolver(unsolvedSheet);
  // sheetSolver.findSolvedNodes();

  var result = await sheetSolver.solve(inputSheet: unsolvedSheet);
  print('result:');
  print(result.finalStatus);
  print('---');
  var sheetPresenter = SheetPresenter();
  sheetPresenter.writeSheet(result.finalSheet);
  print(sheetPresenter.canvas);
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

