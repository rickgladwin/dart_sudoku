import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/service/presenters/sheet_node_presenter.dart';
import 'package:test/test.dart';

import '../../../../test_utilities/comparisons.dart';


void main() {
  group('SheetNodePresenter:', () {
    test('presents a default SheetNode', () {
      final sheetNode = SheetNode();
      final canvas = StringBuffer();
      final knownGoodSheetNode = KnownGood.defaultSheetNode;
      var sheetNodePresenter = SheetNodePresenter(canvas);

      sheetNodePresenter.writeSheetNode(sheetNode: sheetNode, x: 0, y: 0);

      expect(bufferEqualsCodeUnits(sheetNodePresenter.canvas, knownGoodSheetNode), true);
    });
    test('presents a partially solved SheetNode', () {
      final sheetNode = SheetNode({3,6,7});
      final canvas = StringBuffer();
      final knownGoodSheetNode = KnownGood.threeSixSevenSheetNode;
      var sheetNodePresenter = SheetNodePresenter(canvas);

      sheetNodePresenter.writeSheetNode(sheetNode: sheetNode, x: 0, y: 0);

      // print('\n\n\n');
      // sheetNodePresenter.printCanvas();
      // print('\n\n\n');
      // print(sheetNodePresenter.canvas.toString().codeUnits);

      expect(bufferEqualsCodeUnits(sheetNodePresenter.canvas, knownGoodSheetNode), true);
    });
    test('presents a solved SheetNode', () {
      final sheetNode = SheetNode({8});
      final canvas = StringBuffer();
      final knownGoodSheetNode = KnownGood.eightSheetNode;
      var sheetNodePresenter = SheetNodePresenter(canvas);

      sheetNodePresenter.writeSheetNode(sheetNode: sheetNode, x: 0, y: 0);

      // print('\n\n\n');
      // sheetNodePresenter.printCanvas();
      // print('\n\n\n');
      // print(sheetNodePresenter.canvas.toString().codeUnits);

      expect(bufferEqualsCodeUnits(sheetNodePresenter.canvas, knownGoodSheetNode), true);
    });
  });
}

class KnownGood {
  /*
  123
  456
  789
  */
  static const defaultSheetNode = [27, 91, 49, 59, 49, 72, 49, 50, 51, 27, 91, 50, 59, 49, 72, 52, 53, 54, 27, 91, 51, 59, 49, 72, 55, 56, 57, 27, 91, 52, 59, 49, 72];

  /*
    3
    6
  7
   */
  static const threeSixSevenSheetNode = [27, 91, 49, 59, 49, 72, 32, 32, 51, 27, 91, 50, 59, 49, 72, 32, 32, 54, 27, 91, 51, 59, 49, 72, 55, 32, 32, 27, 91, 52, 59, 49, 72];

  /*

   8

  */
  static const eightSheetNode = [27, 91, 49, 59, 49, 72, 32, 32, 32, 27, 91, 50, 59, 49, 72, 32, 56, 32, 27, 91, 51, 59, 49, 72, 32, 32, 32, 27, 91, 52, 59, 49, 72];
}
