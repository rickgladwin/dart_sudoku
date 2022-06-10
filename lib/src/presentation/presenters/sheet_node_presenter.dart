import 'dart:io';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:ansi_escapes/ansi_escapes.dart';


class SheetNodePresenter {
  late final StringBuffer canvas;

  SheetNodePresenter([StringBuffer? canvas]) {
    this.canvas = canvas ?? StringBuffer();
  }

  void writeSheetNode({required SheetNode sheetNode, required int x, required int y}) {
    canvas.write(ansiEscapes.curserTo(x, y));
    int nodeRow = y;
    for (var i = 1; i <= 9; i++) {
      // sleep(Duration(milliseconds:1));
      if (sheetNode.solutions.contains(i)) {
        canvas.write(i);
      } else {
        canvas.write('•');
      }
      if (i % 3 == 0) {
        ++nodeRow;
        canvas.write(ansiEscapes.curserTo(x, nodeRow));
      }
    }
  }

  void printBlankSheetNodes({required int xNodes, required int yNodes}) {
    canvas.write(ansiEscapes.clearScreen);
    // rows
    for(var i = 1; i <= (3 * yNodes); i++) {
      // cols
      for (var j = 1; j <= (3 * xNodes); j++) {
        canvas.write('#');
      }
      canvas.write('\n');
    }
  }

  void printCanvas () => print(canvas);

}

void printCoords(x, y) {
  stdout.write(ansiEscapes.curserTo(0,0));
  stdout.write('x: $x, y: $y');
}

void main() {
  var sheetNode = SheetNode();
  var sheetNodePresenter = SheetNodePresenter();
  sheetNodePresenter.printBlankSheetNodes(xNodes: 1, yNodes: 1);
  sheetNodePresenter.writeSheetNode(sheetNode: sheetNode, x: 0, y: 0);
  sheetNodePresenter.printCanvas();
  print('\ncodeUnits:\n');
  print(sheetNodePresenter.canvas.toString().codeUnits);
  // sleep(Duration(seconds: 1));
  // print('\n***\n');
  // stdout.writeln(sheetNodePresenter.canvas.toString().runes);
  // log(sheetNodePresenter.canvas.toString());
  // print(sheetNodePresenter.canvas.toString());
  // print('\n***\n');

  // sheetNodePresenter.printBlankSheetNodes(xNodes: 9, yNodes: 9);
  // for (var i = 0; i < 9*3; i+=3) {
  //   for (var j = 0; j < 9*3; j+=3) {
  //     sheetNodePresenter.writeSheetNode(sheetNode: sheetNode, x: j, y: i);
  //     sheetNodePresenter.printCanvas();
  //   }
  // }
}
