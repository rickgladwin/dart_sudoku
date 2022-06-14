import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/core/validation_result.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_node_handler.dart';


class SheetHandler {
  final Sheet sheet;

  SheetHandler(this.sheet);

  bool isSolved() {
    // if all SheetNodes are solved, Sheet is solved
    for (var row in sheet.rows) {
      for (var sheetNode in row) {
        if (!SheetNodeHandler(sheetNode).isSolved()) {
          return false;
        }
      }
    }
    return true;
  }

  ValidationResult validateCoords({required int x, required int y}) {
    var validationResult = ValidationResult(status: true);
    if (
      x < 0 || x > 9
    ) {
      validationResult.message = 'x coordinate must be in the range 1..9';
      validationResult.status = false;
    }
    if (
    y < 0 || y > 9
    ) {
      validationResult.message = 'y coordinate must be in the range 1..9';
      validationResult.status = false;
    }

    return validationResult;
  }

  SheetNode getNode({required int x, required int y}) {
    final coordValidation = validateCoords(x: x, y: y);
    if (coordValidation.status == false) {
      throw Exception(coordValidation.message);
    }

    return sheet.rows[y-1][x-1];
  }

  void removeSolutionAt({required int x, required int y, required int solution}) {
    final coordValidation = validateCoords(x: x, y: y);
    if (coordValidation.status == false) {
      throw Exception(coordValidation.message);
    }

    var node = getNode(x: x, y: y);
    SheetNodeHandler(node).removeSolution(solution);
  }

  void updateSolutionsAt({required int x, required int y, required Set<int> newSolutions}) {
    final coordValidation = validateCoords(x: x, y: y);
    if (coordValidation.status == false) {
      throw Exception(coordValidation.message);
    }

    var node = getNode(x: x, y: y);
    SheetNodeHandler(node).updateSolutions(newSolutions);
  }

  bool sheetEquals (Sheet otherSheet) {
    for (var i = 0; i < 9; i ++) {
      for (var j = 0; j < 9; j ++) {
        var solutions1 = sheet.rows[i][j].solutions;
        var solutions2 = otherSheet.rows[i][j].solutions;
        if (solutions1.length != solutions2.length || !solutions1.every(solutions2.contains)) {
          return false;
        }
      }
    }

    return true;
  }

  Sheet clone () {
    // create default sheet
    Sheet cloneSheet = Sheet(SheetInitializer());

    // copy each SheetNode's solution set in the source sheet to the clone sheet
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        cloneSheet.rows[i][j].solutions = sheet.rows[i][j].solutions;
      }
    }

    return cloneSheet;
  }
}
