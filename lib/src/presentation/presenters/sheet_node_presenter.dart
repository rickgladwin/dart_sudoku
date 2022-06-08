import 'dart:io';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:ansi_escapes/ansi_escapes.dart';

// class Char {
//   static final cr = ansiEscapes.cursorNextLine;
//   static final
// }

void printSheetNode(SheetNode sheetNode) {
  printBlankSheetNode();
  stdout.write(ansiEscapes.curserTo(0, 0));
  // var nodeIndex = 1;
  // final Set solutions = sheetNode.solutions;
  for (var i = 1; i <= 9; i++) {
    // TODO: delete (overwrite) any existing character? Or change cursor to
    //  overwrite mode?
    // TODO: cursor right first? Depends on where cursor is placed.
    // stdout.write('\u232B');
    if (sheetNode.solutions.contains(i)) {
      stdout.write(i);
    } else {
      stdout.write('•');
    }
    if (i % 3 == 0) {
      stdout.write(ansiEscapes.cursorNextLine);
      stdout.write(ansiEscapes.cursorLeft);
      stdout.write(ansiEscapes.cursorLeft);
    }
    // ++nodeIndex;
  }
  // TODO: find a way to write buffer without printing newline
  stdout.write('\n');
}

void printBlankSheetNode() {
  stdout.write(ansiEscapes.clearScreen);
  // rows
  for(var i = 1; i <= 3; i++) {
    // cols
    for (var j = 1; j <= 3; j++) {
      stdout.write('#');
    }
    stdout.write('\n');
  }
}