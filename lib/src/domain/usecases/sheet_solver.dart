// the main logic for solving sudoku puzzles

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_solve_result.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_handler.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_node_handler.dart';
import 'package:collection/collection.dart';


class SheetSolver {
  late Sheet sheet;
  Set<SolvedNodeElement> solvedNodes = {};

  SheetSolver(this.sheet);

  void findSolvedNodes() {
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        var sheetNode = sheet.rows[i][j];
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

    print(sectorTopLeft);

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

    // update solvedNodes set
    findSolvedNodes();
    //  if there are no solved nodes, return unsolvable
    if (solvedNodes.isEmpty) {
      result.finalStatus = FinalStatus.unsolvable;
      result.finalSheet = inputSheet;
      return result;
    }

    Sheet sheetBefore = sheet;
    late Sheet sheetAfter;

    // TODO: ensure sheet is passed by reference to both SheetHandler and SheetSolver,
    //  or move clone() to SheetSolver?
    var sheetHandler = SheetHandler(sheet);

    // loop until no updates:
    do {
      // remember sheet before updates
      sheetBefore = sheetHandler.clone();

      for (var solvedNodeElement in solvedNodes) {
        removeSolutions(
            solution: solvedNodeElement.solvedNode.solutions.first,
            exceptX: solvedNodeElement.solvedNodeCoords['x'] as int,
            exceptY: solvedNodeElement.solvedNodeCoords['y'] as int
        );
      }
      // removeSolutions should update sheetSolver.sheet (same sheet as sheetHandler.sheet)
    } while (!sheetHandler.sheetEquals(sheetBefore));

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
