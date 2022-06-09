import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/presentation/presenters/sheet_node_presenter.dart';
import 'package:test/test.dart';

void main() {
  group('SheetNodePresenter', () {
    test('presents a default SheetNode', () {
      var sheetNode = SheetNode();
      printSheetNode(sheetNode);
    });
  });
}