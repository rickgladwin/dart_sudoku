// the main logic for solving sudoku puzzles

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_handler.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_node_handler.dart';

class SheetSolver {
  late Sheet sheet;
  Set<SheetNode> solvedNodes = {};

  SheetSolver(this.sheet);

  void findSolvedNodes() {
    for (var row in sheet.rows) {
      for (var sheetNode in row) {
        if (SheetNodeHandler(sheetNode).isSolved()) {
          solvedNodes.add(sheetNode);
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

    // for (var i = 0; i < 9; i++) {
    //   if (i != exceptY - 1) {
    //     SheetNodeHandler(sheet.columns[i][exceptX - 1]).removeSolution(solution);
    //   }
    // }
  }

  void removeSolutionsFromSector({required int solution, required int sectorX, required int sectorY}) {

    // for (var i = 0; i < 9; i++) {
    //   for
    // }
  }
}

Map sectorCoordFromNodeCoord ({required int nodeX, required int nodeY}) {
  // results can be 1, 4, or 7
  int sectorX;
  int sectorY;
  // FIXME: finish this calc. NOTE: you solved this for 200 vs 300 vs 400 level errors etc.

  sectorX = (nodeX / 3).ceil();
  sectorY = (nodeY / 3).ceil();

  return {
    'x': sectorX,
    'y': sectorY,
  };
}
