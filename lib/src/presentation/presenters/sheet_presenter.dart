import 'dart:io';
import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:ansi_escapes/ansi_escapes.dart';

class Char {
  // grid elements
  static const tl2 = '\u2554';      // top left double line
  static const h2 = '\u2550';       // horizontal double line
  static const h1 = '\u2500';       // horizontal single line
  static const t2v1 = '\u2564';     // top double line with vertical single line
  static const t2v2 = '\u2566';     // top double line with vertical double line
  static const tr2 = '\u2557';
  static const v2 = '\u2551';
  static const v1 = '\u2502';
  static const bl2 = '\u255a';
  static const b2v1 = '\u2567';
  static const b2v2 = '\u2569';
  static const br2 = '\u255d';
  static const l2h1 = '\u255f';
  static const l2h2 = '\u2560';
  static const r2h1 = '\u2562';
  static const r2h2 = '\u2563';
  static const c2 = '\u256c';       // center cross double line
  static const c1 = '\u253c';       // center cross single line
  static const c2h1 = '\u256b';     // center cross double line with horizontal single line
  static const c2v1 = '\u256a';     // center cross double line with vertical single line

  // colors
  static const green = '\u001b[32m';
  static const blue = '\u001b[34m';
  static const yellow = '\u001b[33m';
  static const reset = '\u001b[0m';
}



String presentSheet(Sheet sheet) {
  return 'sheet';
}

void printSheet(Sheet sheet) {
  // printSheetCanvas();
  printSheetBorders();
  stdout.write('\n');
  // print top border
  stdout.write('${Char.tl2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.tr2}\n');
  stdout.write('\n');
  var topLeftNode = sheet.rows[0][0];

  stdout.write(sheet.rows[0][0].solutions);
  stdout.write('\n');
  print('terminal rows: ${stdout.terminalLines}');
  print('terminal columns: ${stdout.terminalColumns}');
  print(sheet);
  print('done');
}

void printSheetCanvas() {
  stdout.write(ansiEscapes.clearScreen);
  for (var i = 0; i < 37; i++) {
    for (var j = 0; j < 37; j++) {
      stdout.write('.');
    }
    stdout.write('\n');
  }

  stdout.write(ansiEscapes.curserTo(0, 0));
  stdout.write(ansiEscapes.cursorMove(3, 5));
  stdout.write('\$');

  // TODO: use ansiEscapes (https://pub.dev/packages/ansi_escapes) to control
  //  cursor position for printing node solutions, lines, etc.
  //
}

void printSheetBorders() {
  stdout.write(ansiEscapes.clearScreen);
  // print top border
  stdout.write('${Char.tl2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.tr2}\n');

  // print rows
  for (var row = 1; row < 36; row++) {
    // line rows
    if (isLineRow(row)) {

    }

    // node rows



    // dummy (dot) rows
    for (var col = 0; col < 37; col++) {
      stdout.write('.');
    }
    stdout.write('\n');
  }
  
  // print bottom border
  stdout.write('${Char.bl2}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.b2v2}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.b2v2}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.br2}\n');
}

bool isLineRow(int row) {
  // total rows (within top and bottom borders):  37
  // line row indices (rows are 1-indexed): 4, 8, 12, 16, 20, 24, 28, 32, 36
  return row % 4 == 0;
}

bool isSectorBorderRow(int row) {
  // every 12th row (every 3rd border row) is a sector border
  // print('$row % 12 = ${row % 12}');
  return row % 12 == 0;
}

void printSheetNode(SheetNode sheetNode, String leftChar, String rightChar) {
  var solutionIndex = 1;
  for (var i = 0; i < 3; i++) {
    for (var j = 0; j < 3; j++) {
      if (sheetNode.solutions.contains(solutionIndex)) {
        stdout.write(solutionIndex);
      } else {
        stdout.write(' ');
      }
    }
  }
}