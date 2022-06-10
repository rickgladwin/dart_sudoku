// the main logic for solving sudoku puzzles

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
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
}