// the main logic for solving sudoku puzzles

// import 'dart:io';

import 'dart:io';

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_solve_result.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_handler.dart';
// import 'package:dart_sudoku/src/domain/usecases/sheet_handler.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_node_handler.dart';
import 'package:collection/collection.dart';
import 'package:dart_sudoku/src/service/presenters/sheet_presenter.dart';
// import 'package:dart_sudoku/src/service/presenters/sheet_presenter.dart';
import 'package:collection/collection.dart';



class SheetSolver {
  late Sheet sheet;
  late final Sheet partialSheet;

  Set<SolvedNodeElement> solvedNodes = {};
  StringBuffer quickHash = StringBuffer();

  SheetSolver(this.sheet);

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

    var sheetPresenter = SheetPresenter();
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

    sheetPresenter = SheetPresenter();


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

      sleep(Duration(milliseconds: 10));

      // sheetPresenter.writeSheet(sheet);
      // print('*** sheet after remove ***');
      // print(sheetPresenter.canvas);

      // print('%%% quickHashBefore: $quickHashBefore');
      // print('%%%  quickHashAfter: $quickHashAfter');
      // print('%%% quickHashBefore != quickHashAfter: ${quickHashBefore != quickHashAfter}');
      // print('&&& total rounds: $rounds');


      promoteSolutions();

      sleep(Duration(milliseconds: 10));

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

    } while (quickHashBefore != quickHashAfter);
    // } while (rounds < 100);

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

  // SheetSolveResult solveWithRecursion ({required Sheet inputSheet}) {
  void solveWithRecursion () {

    // var sheetPresenter = SheetPresenter();
    // sheetPresenter.writeSheet(sheet);
    // print(sheetPresenter.canvas);

    // sheet = inputSheet;
    // var result = SheetSolveResult();

    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        // sleep(Duration(milliseconds: 10));
        // var node = sheet.rows[i][j];
        // if node is default
        // if (sheet.rows[i][j].solutions.length == 9) {
        if (sheet.rows[i][j].solutions.length != 1) {
          // try all values here
          // for (var value = 1; value <= 9; value++) {
            // TODO: figure this out (optimize).
          for (var value in sheet.rows[i][j].solutions) {
            // print('trying  $value at $j,$i');
            if (valueFits(value: value, row: i, col: j)) {
              // print('setting $value at $j,$i');
              sheet.rows[i][j].solutions = {value};
              // solveWithRecursion(inputSheet: sheet);

              // var sheetPresenter = SheetPresenter();
              // sheetPresenter.writeSheet(sheet);
              // print(sheetPresenter.canvas);

              // TODO: see about using Isolates for multi-threading here? Or will that
              //  mess up the memory (for sheet)? The threads all need to update sheet
              //  in a way that doesn't conflict, and they all need to use the same
              //  copy of sheet. So yeah, multithreading might not be appropriate.
              solveWithRecursion();
              //  i.e. did this last call return because it couldn't find a solution or because
              //  it solved the sheet?
              var sheetHandler = SheetHandler(sheet);
              if (!sheetHandler.isSolved()) {
                print('resetting         $j,$i');
                // TODO: figure this out (optimize).
                sheet.rows[i][j].solutions = {1,2,3,4,5,6,7,8,9};
                // sheet.rows[i][j].solutions = partialSheet.rows[i][j].solutions;
              }
              // print('resetting         $j,$i');
              // sheet.rows[i][j].solutions = {1,2,3,4,5,6,7,8,9};
            }
          }
          // print('^^^^^^^^^^^^^^^^ no good value ^^^^^^^^^^^^^^^^^^');
          // exit(0);

          // result.finalStatus = FinalStatus.unsolved;
          // return result;
          // var sheetPresenter = SheetPresenter();
          // sheetPresenter.writeSheet(sheet);
          // print(sheetPresenter.canvas);

          // reached end of value options for this node.
          // return from the current call (should be a recursive call)
          // TODO: return false here to indicate that the sheet isn't done?
          //  Or is it best practice not to return non-void if state is updated?
          //  In this case check state after the return.
          print('all values checked. Returning.');
          return;
        }
      }
    }
    print('############## all nodes checked ###############');
    // result.finalStatus = FinalStatus.solved;
    // result.finalSheet = sheet;

    // return result;
    var sheetPresenter = SheetPresenter();
    sheetPresenter.writeSheet(sheet);
    print(sheetPresenter.canvas);

    // success
    // exit(0);
    print('continue?');
    final input = stdin.readLineSync();
    return;
    // TODO: figure out why this return is never the top level.
    //  Maybe build in a return value based on whether the sheet is solved?
    //  Or check state after the return – if the sheet is complete then don't continue.
  }

  bool valueFits ({required int value, required int row, required int col}) {
    // no matching values in row
    // if (valueInRow(value: value, row: row, exceptCol: col)) return false;
    if (valueInRow(value: value, row: row)) {
      // print('valueFits returning false');
      return false;
    }
    // no matching values in col
    // if (valueInCol(value: value, col: col, exceptRow: row)) return false;
    if (valueInCol(value: value, col: col)) {
      // print('valueFits returning false');

      return false;
    }
    // no matching values in sector
    if (valueInSector(value: value, nodeRow: row, nodeCol: col)) {
      // print('valueFits returning false');

      return false;
    }

    // print('%% valueFits: $value at row: $row, col: $col');

    return true;
  }

  // bool valueInRow ({required int value, required int row, required int exceptCol}) {
  bool valueInRow ({required int value, required int row}) {
    for (var col = 0; col < 9; col++) {
      // if (col != exceptCol && sheet.rows[row][col].solutions == {value}) {
      if (setEquals(sheet.rows[row][col].solutions, {value})) {
        // print('value $value failed for row $row, col $col');
        return true;
      }
    }
    // print('value $value PASSED for row $row');
    return false;
  }

  // bool valueInCol ({required int value, required int col, required int exceptRow}) {
  bool valueInCol ({required int value, required int col}) {
    for (var row = 0; row < 9; row++) {
      // if (row != exceptRow && sheet.rows[row][col].solutions == {value}) {
      if (setEquals(sheet.rows[row][col].solutions, {value})) {
        // print('value $value failed for row $row, col $col');
        return true;
      }
    }
    // print('value $value PASSED for col $col');
    return false;
  }

  bool valueInSector ({required int value, required int nodeRow, required int nodeCol}) {
    final sectorCoords = sectorCoordFromNodeCoord(nodeX: nodeCol + 1, nodeY: nodeRow + 1);
    final sectorRow = (sectorCoords['y'] as int) - 1;
    final sectorCol = (sectorCoords['x'] as int) - 1;
    for (var row = sectorRow; row < sectorRow + 3; row++) {
      for (var col = sectorCol; col < sectorCol + 3; col++) {

        // i != (nodeY - 1) || j != (nodeX - 1)

        // if (row != nodeRow && col != nodeCol && sheet.rows[row][col].solutions == {value}) {
        if (setEquals(sheet.rows[row][col].solutions, {value})) {
          // print('value $value failed for row $row, col $col');
          return true;
        }
      }
    }
    // print('value $value PASSED for sector at sectorRow $sectorRow, sectorCol $sectorCol');
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
  // var unsolvedSheet = createDummySheetFromData(Stub.solvableNYTHardSheetData);
  // var unsolvedSheet = createDummySheetFromData(Stub.sudokuDragonStuckPuzzle1);
  // var unsolvedSheet = createDummySheetFromData(Stub.solvableExpertSheetData2);
  // var unsolvedSheet = createDummySheetFromData(Stub.solvableExpertSheetData);
  var unsolvedSheet = createDummySheetFromData(Stub.solvableEvilSheetData);


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
  print('-- solving sheet:');
  var sheetPresenter = SheetPresenter();
  sheetPresenter.writeSheet(unsolvedSheet);
  print(sheetPresenter.canvas);

  // var sheetInitializer = SheetInitializer(rowData: sheetNodeData);
  // var unsolvedSheet = Sheet(sheetInitializer);
  var sheetSolver = SheetSolver(unsolvedSheet);
  // sheetSolver.findSolvedNodes();
  // print('waiting 2 seconds...');
  // sleep(Duration(milliseconds: 2000));
  var result = await sheetSolver.solve(inputSheet: unsolvedSheet);
  // var result = sheetSolver.solveWithRecursion(inputSheet: unsolvedSheet);
  // var result = sheetSolver.solveWithRecursion();

  // var sheetHandler = SheetHandler(result.finalSheet);

  // TODO: create a parent method 'solve' that calls solveWithoutRecursion()
  //  and solveWithRecursion() (conditionally) to solve all classes of puzzles
  //  with maximum efficiency (barring codifying sudoku strategies)

  // TODO: write final tests and clean up the code

  // TODO: publish this as a Dart package so it can be imported into Flutter

  // TODO: build the Flutter app around this core

  if (result.finalStatus != FinalStatus.solved) {
    print('basic methods could not complete the solution. Continue with recursion?');
    sheetSolver.partialSheet = result.finalSheet;
    var input = stdin.readLineSync();
    sheetSolver.solveWithRecursion();
    print('solved WITH recursion:');
    // TODO: set a final sheet matching the result from basic methods, and reset
    //  nodes to THAT sheet's nodes in the recursive method, rather than the default.
    //  ALSO, try just the remaining values, NOT the full 1..9
    sheetPresenter.writeSheet(sheetSolver.sheet);
    print(sheetPresenter.canvas);
  } else {
    print('solved without recursion:');
    sheetPresenter.writeSheet(result.finalSheet);
    print(sheetPresenter.canvas);
  }


  // result.finalSheet = sheetSolver.sheet;

  print('done');
  // print(result.finalStatus);
  // print('---');
  // sheetPresenter.writeSheet(result.finalSheet);
  // print(sheetPresenter.canvas);
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

  /// gets to this state:
  // ╔═══╤═══╤═══╦═══╤═══╤═══╦═══╤═══╤═══╗
  // ║   │   │   ║   │   │   ║   │   │   ║
  // ║ 7 │ 9 │ 6 ║ 5 │ 2 │ 3 ║ 1 │ 4 │ 8 ║
  // ║   │   │   ║   │   │   ║   │   │   ║
  // ╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
  // ║1  │   │   ║1  │   │1  ║   │   │   ║
  // ║ 5 │ 4 │ 5 ║  6│   │  6║ 56│ 2 │ 3 ║
  // ║ 8 │   │ 8 ║78 │789│  9║7  │   │   ║
  // ╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
  // ║1  │   │   ║1  │   │1  ║   │   │   ║
  // ║ 5 │ 3 │ 2 ║  6│ 4 │  6║ 9 │ 56│ 56║
  // ║ 8 │   │   ║78 │   │   ║   │7  │7  ║
  // ╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
  // ║   │   │  3║  3│  3│   ║   │   │   ║
  // ║ 4 │ 2 │ 5 ║  6│ 5 │ 56║ 8 │ 1 │ 9 ║
  // ║   │   │7  ║7  │7  │   ║   │   │   ║
  // ╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
  // ║   │   │   ║   │   │   ║   │   │   ║
  // ║ 5 │ 6 │ 5 ║   │ 1 │ 2 ║ 4 │ 3 │ 5 ║
  // ║ 89│   │789║78 │   │   ║   │   │7  ║
  // ╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
  // ║  3│   │  3║  3│  3│   ║   │   │   ║
  // ║ 5 │ 1 │ 5 ║4 6│ 5 │456║ 2 │ 56│ 56║
  // ║ 89│   │789║78 │789│  9║   │7  │7  ║
  // ╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
  // ║   │   │   ║   │   │   ║   │   │   ║
  // ║ 2 │ 5 │ 4 ║ 9 │ 6 │ 7 ║ 3 │ 8 │ 1 ║
  // ║   │   │   ║   │   │   ║   │   │   ║
  // ╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
  // ║  3│   │   ║   │  3│   ║   │   │   ║
  // ║  6│ 7 │ 1 ║ 2 │ 5 │ 8 ║ 56│ 56│ 4 ║
  // ║  9│   │   ║   │   │   ║   │  9│   ║
  // ╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
  // ║  3│   │  3║1 3│  3│1  ║   │   │   ║
  // ║  6│ 8 │   ║4  │ 5 │45 ║ 56│ 56│ 2 ║
  // ║  9│   │  9║   │   │   ║7  │7 9│   ║
  // ╚═══╧═══╧═══╩═══╧═══╧═══╩═══╧═══╧═══╝
  /// and can't get further. The solved nodes in this
  /// partially solved sheet are correct. Haven't been
  /// able to find the next solution manually.
  /// Consider the recursive solution from
  /// https://www.youtube.com/watch?v=G_UYXzGuqvM
  /// Is it possible to solve hard/all Sudoku puzzles using
  /// only the checks outlined here? Does it need to be predictive
  /// at all? Forums are saying that it should be possible, but then
  /// it's possible to create Sudoku puzzles with more than one solution.
  /// The question is, do these test puzzles have more than one solution?
  /// Seems to be the case that if the puzzle has one solution,
  /// it should be possible to solve it using these rules. But other
  /// classes of Sudoku puzzle will require recursion and backtracking.
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
}

