// the main logic for solving sudoku puzzles

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_solve_result.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_handler.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_node_handler.dart';
import 'package:collection/collection.dart';
import 'package:dart_sudoku/src/service/presenters/sheet_presenter.dart';


class SheetSolver {
  Sheet sheet;
  late final Sheet? partialSheet;

  Set<SolvedNodeElement> solvedNodes = {};
  StringBuffer quickHash = StringBuffer();

  SheetSolver(this.sheet) {
    updateSolvedNodesAndQuickHash();
  }

  Function setEquals = const SetEquality().equals;

  void updateSolvedNodesAndQuickHash() {
    solvedNodes.clear();
    quickHash.clear();
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        var sheetNode = sheet.rows[i][j];
        // update quickHash
        for (var element in sheetNode.solutions) {quickHash.write(element);}

        if (SheetNodeHandler(sheetNode).isSolved()) {
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
        // check all columns for value
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

  Future<SheetSolveResult> solve () async {

    var result = await solveBasic();

    // var sheetPresenter = SheetPresenter();

    if (result.finalStatus != FinalStatus.solved) {
      var sheetHandler = SheetHandler(result.finalSheet);

      partialSheet = sheetHandler.clone();
      solveWithRecursion();
      result.finalStatus = solvedNodes.length == 81 ? FinalStatus.solved : FinalStatus.unsolvable;
      result.finalSheet = sheet;

    }

    return result;
  }

  Future<SheetSolveResult> solveBasic() async {
    var result = SheetSolveResult();
    result.finalStatus = FinalStatus.unsolved;

    var sheetPresenter = SheetPresenter();

    updateSolvedNodesAndQuickHash();

    //  if there are no solved nodes, return unsolvable
    if (solvedNodes.isEmpty) {
      result.finalStatus = FinalStatus.unsolvable;
      result.finalSheet = sheet;
      return result;
    }

    int solvedNodesCountBefore;
    int solvedNodesCountAfter;
    String quickHashBefore;
    String quickHashAfter;

    var rounds = 0;

    sheetPresenter = SheetPresenter();

    // loop until no updates:
    do {
      updateSolvedNodesAndQuickHash();

      // remember solutions count before updates
      solvedNodesCountBefore = solvedNodes.length;
      quickHashBefore = quickHash.toString();

      for (var solvedNodeElement in solvedNodes) {
        if (solvedNodeElement.solvedNode.solutions.isNotEmpty) {
          removeSolutions(
              solution: solvedNodeElement.solvedNode.solutions.first,
              exceptX: solvedNodeElement.solvedNodeCoords['x'] as int,
              exceptY: solvedNodeElement.solvedNodeCoords['y'] as int
          );
        }
      }

      promoteSolutions();

      updateSolvedNodesAndQuickHash();

      solvedNodesCountAfter = solvedNodes.length;
      quickHashAfter = quickHash.toString();
      sheetPresenter.writeSheet(sheet);

      ++rounds;

    } while (quickHashBefore != quickHashAfter);

    if (solvedNodes.length == 81) {
      result.finalStatus = FinalStatus.solved;
    } else {
      result.finalStatus = FinalStatus.unsolvable;
    }

    result.finalSheet = sheet;

    return result;
  }


  void solveWithRecursion () {

    partialSheet ??= SheetHandler(sheet).clone();

    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        // if node is unsolved
        if (sheet.rows[i][j].solutions.length != 1) {
          // try all values here
          for (var value in sheet.rows[i][j].solutions) {
            if (valueFits(value: value, row: i, col: j)) {
              sheet.rows[i][j].solutions = {value};
              solveWithRecursion();
              updateSolvedNodesAndQuickHash();
              var sheetHandler = SheetHandler(sheet);
              if (!sheetHandler.isSolved()) {
                sheet.rows[i][j].solutions = partialSheet!.rows[i][j].solutions;
              }
            }
          }
          // reached end of value options for this node.
          // return from the current call (should be a recursive call)
          return;
        }
      }
    }

    updateSolvedNodesAndQuickHash();

    return;
  }

  bool valueFits ({required int value, required int row, required int col}) {
    // no matching values in row
    if (valueInRow(value: value, row: row)) {

      return false;
    }
    // no matching values in col
    if (valueInCol(value: value, col: col)) {

      return false;
    }
    // no matching values in sector
    if (valueInSector(value: value, nodeRow: row, nodeCol: col)) {

      return false;
    }

    return true;
  }

  bool valueInRow ({required int value, required int row}) {
    for (var col = 0; col < 9; col++) {
      if (setEquals(sheet.rows[row][col].solutions, {value})) {

        return true;
      }
    }

    return false;
  }

  bool valueInCol ({required int value, required int col}) {
    for (var row = 0; row < 9; row++) {
      if (setEquals(sheet.rows[row][col].solutions, {value})) {

        return true;
      }
    }

    return false;
  }

  bool valueInSector ({required int value, required int nodeRow, required int nodeCol}) {
    final sectorCoords = sectorCoordFromNodeCoord(nodeX: nodeCol + 1, nodeY: nodeRow + 1);
    final sectorRow = (sectorCoords['y'] as int) - 1;
    final sectorCol = (sectorCoords['x'] as int) - 1;
    for (var row = sectorRow; row < sectorRow + 3; row++) {
      for (var col = sectorCol; col < sectorCol + 3; col++) {

        if (setEquals(sheet.rows[row][col].solutions, {value})) {

          return true;
        }
      }
    }

    return false;
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

  // can be solved using basic methods
  // var unsolvedSheet = createDummySheetFromData(Stub.solvableMediumSheetData2);
  // var unsolvedSheet = createDummySheetFromData(Stub.solvableHardSheetData);
  // var unsolvedSheet = createDummySheetFromData(Stub.solvableEasySheetData);
  // var unsolvedSheet = createDummySheetFromData(Stub.solvableHardSheetData3);

  // requires recursion (but solves in a reasonable time via recursion)
  // NOTE: turn off intermediate prints (or use an Isolate for printing)
  //  when using recursion.
  var unsolvedSheet = createDummySheetFromData(Stub.solvableNYTHardSheetData);
  // var unsolvedSheet = createDummySheetFromData(Stub.sudokuDragonStuckPuzzle1);
  // var unsolvedSheet = createDummySheetFromData(Stub.solvableExpertSheetData2);
  // var unsolvedSheet = createDummySheetFromData(Stub.solvableExpertSheetData);
  // var unsolvedSheet = createDummySheetFromData(Stub.solvableEvilSheetData);
  // NOTE: this one takes almost 2 seconds (with some extra line prints). A real doozy.
  //  Also, none of it can be solved using basic methods. Starts with 21 solutions,
  //  hits the recursion phase with 21 solutions. Cool.
  // var unsolvedSheet = createDummySheetFromData(Stub.sudokuArtoInkalaPuzzle);

  print('-- solving sheet:');
  var sheetPresenter = SheetPresenter();
  sheetPresenter.writeSheet(unsolvedSheet);
  print(sheetPresenter.canvas);

  var sheetSolver = SheetSolver(unsolvedSheet);

  var result = await sheetSolver.solve();

  // TODO: clean up the code

  // TODO: publish this as a Dart package so it can be imported into Flutter

  // TODO: build the Flutter app around this core

  sheetPresenter.writeSheet(result.finalSheet);
  print(sheetPresenter.canvas);


  print('done');
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

  static const solvableEasySheetData = [
    [0,0,1,4,0,0,0,2,6],
    [4,2,0,0,0,0,0,0,0],
    [0,0,0,1,0,0,0,3,7],
    [8,1,0,0,6,4,7,9,0],
    [9,4,0,2,0,7,0,5,3],
    [0,3,7,5,8,0,0,1,4],
    [5,7,0,0,0,1,0,0,0],
    [0,0,0,0,0,0,0,4,9],
    [3,8,0,0,0,5,2,0,0],
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

  static const solvableMediumSheetData2 = [
    [0,0,3,9,2,0,0,4,0],
    [0,0,8,0,0,4,0,0,3],
    [0,0,0,0,3,0,0,0,0],
    [3,8,4,0,0,0,6,0,9],
    [0,9,0,0,0,0,0,1,0],
    [7,0,6,0,0,0,4,8,2],
    [0,0,0,0,7,0,0,0,0],
    [6,0,0,5,0,0,8,0,0],
    [0,4,0,0,6,8,2,0,0],
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

  static const solvableHardSheetData3 = [
    [5,7,0,0,8,0,0,0,0],
    [1,0,6,9,0,0,8,0,0],
    [0,0,0,0,6,3,0,0,0],
    [0,0,0,4,0,0,0,9,6],
    [0,3,0,0,9,0,0,5,0],
    [7,6,0,0,0,1,0,0,0],
    [0,0,0,6,1,0,0,0,0],
    [0,0,8,0,0,9,2,0,1],
    [0,0,0,0,3,0,0,8,4],
  ];

  // hard unsolved
  static const solvableNYTHardSheetData = [
    [7,0,6,5,2,0,1,0,0],
    [0,0,0,0,0,0,0,2,0],
    [0,3,0,0,4,0,9,0,0],
    [4,0,0,0,0,0,0,0,9],
    [0,0,0,0,1,2,0,3,0],
    [0,0,0,0,0,0,2,0,0],
    [0,5,0,9,6,0,3,0,0],
    [0,7,1,0,0,8,0,0,4],
    [0,8,0,0,0,0,0,0,0],
  ];

  /// https://www.youtube.com/watch?v=G_UYXzGuqvM
  ///
  /// Further reading: https://www.sudokudragon.com/unsolvable.htm
  /// Note: strategies like "alternative pair" etc. seem to be summaries
  /// of logic that would emerge from recursion and backtracking.
  /// Stable results, essentially. You might be able to generate the
  /// strategies themselves in the abstract, by abstracting the states
  /// and state changes associated with recursion and backtracking.
  /// Could an AI learn them as shortcuts? Maybe.

  // hard solved
  static const solvedNYTHardSheetData = [
    [7,9,6,5,2,3,1,4,8],
    [1,4,5,7,8,9,6,2,3],
    [8,3,2,1,4,6,9,5,7],
    [4,2,3,6,7,5,8,1,9],
    [9,6,7,8,1,2,4,3,5],
    [5,1,8,3,9,4,2,7,6],
    [2,5,4,9,6,7,3,8,1],
    [6,7,1,2,3,8,5,9,4],
    [3,8,9,4,5,1,7,6,2],
  ];

  static const solvableExpertSheetData = [
    [3,0,4,0,0,6,0,0,0],
    [0,6,0,0,0,0,0,0,0],
    [0,0,0,0,7,0,2,5,0],
    [0,0,0,2,0,9,7,0,0],
    [0,0,0,6,8,5,0,0,0],
    [0,2,0,0,0,0,0,9,0],
    [9,0,1,0,0,0,4,0,0],
    [0,0,8,0,4,0,0,1,5],
    [0,0,0,0,0,0,0,0,3],
  ];

  static const solvableExpertSheetData2 = [
    [0,0,0,0,0,0,0,8,0],
    [0,4,0,0,1,0,3,0,6],
    [0,0,2,0,0,0,0,0,7],
    [3,0,0,0,6,0,4,0,0],
    [4,0,0,1,8,0,0,0,0],
    [0,0,0,3,0,0,9,2,0],
    [0,8,0,0,0,0,0,7,0],
    [0,0,0,0,0,9,0,0,0],
    [6,1,3,8,0,0,0,0,0],
  ];

  static const solvableEvilSheetData = [
    [0,9,0,0,7,0,0,4,6],
    [0,0,0,3,0,0,0,0,0],
    [0,7,0,2,0,0,0,0,5],
    [0,0,2,0,0,0,0,0,1],
    [0,6,7,0,0,0,8,3,0],
    [1,0,0,0,0,0,2,0,0],
    [7,0,0,0,0,6,0,2,0],
    [0,0,0,0,0,4,0,0,0],
    [3,4,0,0,8,0,0,6,0],
  ];

  static const sudokuDragonStuckPuzzle1 = [
    [0,0,0,0,7,4,3,1,6],
    [0,0,0,6,0,3,8,4,0],
    [0,0,0,0,0,8,5,0,0],
    [7,2,5,8,0,0,0,3,4],
    [0,0,0,0,3,0,0,5,0],
    [0,0,0,0,0,2,7,9,8],
    [0,0,8,9,4,0,0,0,0],
    [0,4,0,0,8,5,9,0,0],
    [9,7,1,3,2,6,4,8,5],
  ];

  static const sudokuArtoInkalaPuzzle = [
    [8,0,0,0,0,0,0,0,0],
    [0,0,3,6,0,0,0,0,0],
    [0,7,0,0,9,0,2,0,0],
    [0,5,0,0,0,7,0,0,0],
    [0,0,0,0,4,5,7,0,0],
    [0,0,0,1,0,0,0,3,0],
    [0,0,1,0,0,0,0,6,8],
    [0,0,8,5,0,0,0,1,0],
    [0,9,0,0,0,0,4,0,0],
  ];
}
