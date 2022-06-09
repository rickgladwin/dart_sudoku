import 'dart:io';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:ansi_escapes/ansi_escapes.dart';


void printSheetNode({required SheetNode sheetNode, required int x, required int y}) {
  stdout.write(ansiEscapes.curserTo(x, y));
  // sleep(Duration(milliseconds:10));
  int nodeRow = y;
  for (var i = 1; i <= 9; i++) {
    sleep(Duration(milliseconds:5));
    if (sheetNode.solutions.contains(i)) {
      stdout.write(i);
    } else {
      stdout.write('•');
    }
    if (i % 3 == 0) {
      ++nodeRow;
      stdout.write(ansiEscapes.curserTo(x, nodeRow));
    }
  }
  // TODO: find a way to write buffer without printing newline
  stdout.write('\n\n\n');
}

void printCoords(x, y) {
  stdout.write(ansiEscapes.curserTo(0,0));
  stdout.write('x: $x, y: $y');
}

void printBlankSheetNodes({required int xNodes, required int yNodes}) {
  stdout.write(ansiEscapes.clearScreen);
  // rows
  for(var i = 1; i <= (3 * yNodes); i++) {
    // cols
    for (var j = 1; j <= (3 * xNodes); j++) {
      stdout.write('#');
    }
    stdout.write('\n');
  }
}

void main() {
  var sheetNode = SheetNode();
  printBlankSheetNodes(xNodes: 9, yNodes: 9);
  for (var i = 0; i < 9*3; i+=3) {
    for (var j = 0; j < 9*3; j+=3) {
      printSheetNode(sheetNode: sheetNode, x: j, y: i);
    }
  }
}