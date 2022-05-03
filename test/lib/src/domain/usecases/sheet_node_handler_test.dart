import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_node_handler.dart';
import "package:test/test.dart";

void main() {
  group('SheetNodeHandler', () {
    test('can update with fewer solutions', () {
      var sheetNode = SheetNode({1,2,3,4,5,6,7});
      var sheetNodeHandler = SheetNodeHandler(sheetNode);
      const Set<int> fewerSolutions = {1,3,6,7}; // a subset of existing solutions

      sheetNodeHandler.updateSolutions(fewerSolutions);

      expect(sheetNode.solutions, equals(fewerSolutions));
    });

    test('cannot update with more solutions', () {
      var sheetNode = SheetNode({1,2,3,4,5,6,7});
      var sheetNodeHandler = SheetNodeHandler(sheetNode);
      const Set<int> moreSolutions = {1,3,6,7,8}; // 8 has been added

      expect(() => sheetNodeHandler.updateSolutions(moreSolutions), throwsException);
    });

    test('removes a solution', () {
      var sheetNode = SheetNode({1,2,3,4});
      var sheetNodeHandler = SheetNodeHandler(sheetNode);

      sheetNodeHandler.removeSolution(3);

      expect(sheetNode.solutions, equals({1,2,4}));
    });

    test('leaves a solution removed if already removed', () {
      var sheetNode = SheetNode({1,2,3,4});
      var sheetNodeHandler = SheetNodeHandler(sheetNode);

      sheetNodeHandler.removeSolution(5);

      expect(sheetNode.solutions, equals({1,2,3,4}));
    });

    test('can have solved status', () {
      var solvedSheetNode = SheetNode({2});
      var sheetNodeHandler = SheetNodeHandler(solvedSheetNode);

      expect(sheetNodeHandler.isSolved(), equals(true));
    });

    test('can have unsolved status', () {
      var unsolvedSheetNode = SheetNode({2,3});
      var sheetNodeHandler = SheetNodeHandler(unsolvedSheetNode);

      expect(sheetNodeHandler.isSolved(), equals(false));
    });

    group('validateNewSolutions', () {
      test('invalidates a new solution set which includes a removed solution', () {
        var sheetNode = SheetNode({1,2,3,4,5,6,7});
        var sheetNodeHandler = SheetNodeHandler(sheetNode);
        const Set<int> moreSolutions = {1,3,6,7,8}; // 8 has been added
        
        var validationResult = sheetNodeHandler.validateNewSolutions(moreSolutions);
        
        expect(validationResult.status, equals(false));
      });

      test('invalidates a new solution set which includes an invalid number', () {
        var sheetNode = SheetNode({1,2,3,4,5,6,7});
        var sheetNodeHandler = SheetNodeHandler(sheetNode);
        const Set<int> moreSolutions = {1,3,6,7,12}; // 12 is invalid

        var validationResult = sheetNodeHandler.validateNewSolutions(moreSolutions);

        expect(validationResult.status, equals(false));
      });

      test('validates a new solution set which does not include a removed solution', () {
        var sheetNode = SheetNode({1,2,3,4,5,6,7});
        var sheetNodeHandler = SheetNodeHandler(sheetNode);
        const Set<int> moreSolutions = {1,3,6,7}; // new solutions are a subset

        var validationResult = sheetNodeHandler.validateNewSolutions(moreSolutions);

        expect(validationResult.status, equals(true));
      });


    });
  });
}
