import 'dart:io';

import 'package:ansi_escapes/ansi_escapes.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/presentation/presenters/sheet_node_presenter.dart';
import 'package:test/test.dart';

import '../../../../test_utilities/comparisons.dart';


class KnownGood {
  // 123
  // 456
  // 789
  static const defaultSheetNode = [27, 91, 49, 59, 49, 72, 49, 50, 51, 27, 91, 50, 59, 49, 72, 52, 53, 54, 27, 91, 51, 59, 49, 72, 55, 56, 57, 27, 91, 52, 59, 49, 72];
}

void main() {
  group('SheetNodePresenter', () {
    test('presents a default SheetNode', () async {
      // stdout.write(ansiEscapes.clearScreen);
      final sheetNode = SheetNode();
      final canvas = StringBuffer();
      final knownGoodSheetNode = KnownGood.defaultSheetNode;
      var sheetNodePresenter = SheetNodePresenter(canvas);

      sheetNodePresenter.writeSheetNode(sheetNode: sheetNode, x: 0, y: 0);

      // print('\n***\n');
      // stdout.writeln(sheetNodePresenter.canvas.toString().codeUnits);
      // print('\n***\n');
      // print(knownGoodSheetNode.toString().runes);
      expect(bufferEqualsCodeUnits(sheetNodePresenter.canvas, knownGoodSheetNode), true);
      // expect(sheetNodePresenter.canvas, equals(knownGoodSheetNode));


      // stdout.write('\n\n\n\n');
      // sleep(Duration(seconds: 2));
      // read canvas
      // stdout.write(ansiEscapes.curserTo(0, 0));
      // var checkChar = await stdin.elementAt(2);
      // stdout.write('\n');
      // print(checkChar);
      // print('okay');
    });
    // });
  });
}
