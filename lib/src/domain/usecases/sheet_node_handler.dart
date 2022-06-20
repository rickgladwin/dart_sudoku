// handles use cases for SheetNode

import 'package:dart_sudoku/src/core/validation_result.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';


class SheetNodeHandler {
  final SheetNode sheetNode;

  SheetNodeHandler(this.sheetNode);

  void updateSolutions(Set<int> newSolutions) {
    var validationResult = validateNewSolutions(newSolutions);
    if (validationResult.status == true) {
      sheetNode.solutions = newSolutions;
    } else {
      throw Exception(validationResult.message);
    }
  }

  bool isSolved() {
    return sheetNode.solutions.length == 1;
  }

  ValidationResult validateNewSolutions(Set<int> newSolutions) {
    var validationResult = ValidationResult(status: true);

    // new solutions cannot contain an invalid integer
    for (var newSolution in newSolutions) {
      if (newSolution < 1 || newSolution > 9) {
        validationResult.message = "solution values must be in the range 1..9";
        validationResult.status = false;
        break;
      }
    }

    // new solutions cannot contain a non-existent value
    for (var newSolution in newSolutions) {
      if (!sheetNode.solutions.contains(newSolution)) {
        validationResult.message = "existing solution list does not contain the new solution(s)";
        validationResult.status = false;
        break;
      }
    }

    return validationResult;
  }

  void removeSolution(int solution) {
    if (sheetNode.solutions.contains(solution)) {
      sheetNode.solutions.remove(solution);
    }
  }
}
