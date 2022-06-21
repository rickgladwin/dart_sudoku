// import 'dart:io';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:ansi_escapes/ansi_escapes.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_node_handler.dart';

class Chars {
  // static const removed = '•';
  static const removed = ' ';
  static const canvasBlank = ' ';
  static const nodeBlank = ' ';
}


class SheetNodePresenter {
  late final StringBuffer canvas;

  SheetNodePresenter([StringBuffer? canvas]) {
    this.canvas = canvas ?? StringBuffer();
  }

  void writeSheetNode({required SheetNode sheetNode, required int x, required int y}) {
    canvas.write(ansiEscapes.cursorTo(x, y));

    if (SheetNodeHandler(sheetNode).isSolved()) {
      writeSolvedSheetNode(sheetNode: sheetNode, x: x, y: y);
    } else {
      writeUnsolvedSheetNode(sheetNode: sheetNode, x: x, y: y);
    }
  }

  void writeUnsolvedSheetNode({required SheetNode sheetNode, required int x, required int y}) {
    int nodeRow = y;
    for (var i = 1; i <= 9; i++) {
      if (sheetNode.solutions.contains(i)) {
        canvas.write(i);
      } else {
        canvas.write(Chars.removed);
      }
      if (i % 3 == 0) {
        ++nodeRow;
        canvas.write(ansiEscapes.cursorTo(x, nodeRow));
      }
    }
  }

  void writeSolvedSheetNode({required SheetNode sheetNode, required int x, required int y}) {
    int nodeRow = y;
    int solution = sheetNode.solutions.first;

    for (var i = 1; i <= 9; i++) {
      if (i == 5) {
        canvas.write(solution);
      } else {
        canvas.write(Chars.nodeBlank);
      }
      if (i % 3 == 0) {
        ++nodeRow;
        canvas.write(ansiEscapes.cursorTo(x, nodeRow));
      }
    }
  }
}
