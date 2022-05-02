// unit tests for sheet_node entities

import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:test/test.dart';

void main() {
  group('SheetNode', () {
    test('initializes with all possible values by default', () {
      var sheetNode = SheetNode();
      const expectedSheetNodeSolutions = [1,2,3,4,5,6,7,8,9];
      expect(sheetNode.solutions, equals(expectedSheetNodeSolutions));
    });

    test('initializes with arguments', () {
      const initSolutions = [1,2,5,7,8];
      var sheetNode = SheetNode(initSolutions);
      expect(sheetNode.solutions, equals(initSolutions));
    });
  });
}
