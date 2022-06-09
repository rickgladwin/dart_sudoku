import 'dart:io';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:ansi_escapes/ansi_escapes.dart';

// class Char {
//   static final cr = ansiEscapes.cursorNextLine;
//   static final
// }



void printSheetNode({required SheetNode sheetNode, required int x, required int y}) {
  stdout.write(ansiEscapes.curserTo(x, y));
  sleep(Duration(seconds:1));
  int nodeRow = y;
  for (var i = 1; i <= 9; i++) {
    sleep(Duration(milliseconds:100));
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
  // var cursorPosition = ansiEscapes.cursorGetPosition;
  stdout.write(ansiEscapes.curserTo(0,0));
  stdout.write('x: $x, y: $y');
  // stdout.write(ansiEscapes.curserTo(cursorPosition.x, cursorPosition.y))
}

void printBlankSheetNode() {

  stdout.write(ansiEscapes.clearScreen);
  stdout.write('\n');
  // rows
  for(var i = 1; i <= 3; i++) {
    // cols
    for (var j = 1; j <= 3; j++) {
      stdout.write('#');
    }
    stdout.write('\n');
  }
}

void printFourBlankSheetNodes() {
  stdout.write(ansiEscapes.clearScreen);
  // rows
  for(var i = 1; i <= 6; i++) {
    // cols
    for (var j = 1; j <= 6; j++) {
      stdout.write('#');
    }
    stdout.write('\n');
  }
}

void main() {
  var sheetNode = SheetNode();
  printFourBlankSheetNodes();
  printSheetNode(sheetNode: sheetNode, x: 0, y: 0);
  printSheetNode(sheetNode: sheetNode, x: 3, y: 0);
  printSheetNode(sheetNode: sheetNode, x: 0, y: 3);
  printSheetNode(sheetNode: sheetNode, x: 3, y: 3);
}