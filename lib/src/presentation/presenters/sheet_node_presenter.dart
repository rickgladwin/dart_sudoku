import 'dart:io';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:ansi_escapes/ansi_escapes.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_node_handler.dart';

class Chars {
  // static const removed = '•';
  static const removed = ' ';
  static const canvasBlank = '#';
  static const nodeBlank = ' ';
}


class SheetNodePresenter {
  late final StringBuffer canvas;

  SheetNodePresenter([StringBuffer? canvas]) {
    this.canvas = canvas ?? StringBuffer();
  }

  void writeSheetNode({required SheetNode sheetNode, required int x, required int y}) {
    canvas.write(ansiEscapes.curserTo(x, y));

    if (SheetNodeHandler(sheetNode).isSolved()) {
      writeSolvedSheetNode(sheetNode: sheetNode, x: x, y: y);
    } else {
      writeUnsolvedSheetNode(sheetNode: sheetNode, x: x, y: y);
    }

    // int nodeRow = y;
    // for (var i = 1; i <= 9; i++) {
    //   // sleep(Duration(milliseconds:1));
    //   if (sheetNode.solutions.contains(i)) {
    //     canvas.write(i);
    //   } else {
    //     canvas.write(Chars.removed);
    //   }
    //   if (i % 3 == 0) {
    //     ++nodeRow;
    //     canvas.write(ansiEscapes.curserTo(x, nodeRow));
    //   }
    // }
  }

  void writeUnsolvedSheetNode({required SheetNode sheetNode, required int x, required int y}) {
    int nodeRow = y;
    for (var i = 1; i <= 9; i++) {
      // sleep(Duration(milliseconds:1));
      if (sheetNode.solutions.contains(i)) {
        canvas.write(i);
      } else {
        canvas.write(Chars.removed);
      }
      if (i % 3 == 0) {
        ++nodeRow;
        canvas.write(ansiEscapes.curserTo(x, nodeRow));
      }
    }
  }

  void writeSolvedSheetNode({required SheetNode sheetNode, required int x, required int y}) {
    int nodeRow = y;
    int solution = sheetNode.solutions.first;

    for (var i = 1; i <= 9; i++) {
      // sleep(Duration(milliseconds:1));
      if (i == 5) {
        canvas.write(solution);
      } else {
        canvas.write(Chars.nodeBlank);
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
        canvas.write(Chars.canvasBlank);
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
  // var sheetNode = SheetNode();
  // var sheetNode = SheetNode({3,6,7});
  var sheetNode = SheetNode({8});
  var sheetNodePresenter = SheetNodePresenter();
  // sheetNodePresenter.printBlankSheetNodes(xNodes: 1, yNodes: 1);
  sheetNodePresenter.writeSheetNode(sheetNode: sheetNode, x: 0, y: 0);

  sheetNodePresenter.printCanvas();
  print('\ncodeUnits:\n');
  print(sheetNodePresenter.canvas.toString().codeUnits);
}
