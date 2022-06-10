import 'dart:io';
import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:ansi_escapes/ansi_escapes.dart';
import 'package:dart_sudoku/src/presentation/presenters/sheet_node_presenter.dart';

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
  static const l2h1 = '\u255f';     // left double with horizontal single line
  static const l2h2 = '\u2560';     // left double with horizontal double line
  static const r2h1 = '\u2562';     // right double with horizontal single line
  static const r2h2 = '\u2563';     // right double with horizontal double line
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

class SheetPresenter {
  late final StringBuffer canvas;

  SheetPresenter([StringBuffer? canvas]) {
    this.canvas = canvas ?? StringBuffer();
  }

  void writeSheetBorders() {
    // TODO: clear buffer here?
    canvas.write(ansiEscapes.clearScreen);
    // print top border
    canvas.write('${Char.tl2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.tr2}\n');

    // print rows
    for (var row = 1; row < 36; row++) {

      late final String leftVert;
      late final String rightVert;
      late final String horizLine;
      late final String horizNodeCross;
      late final String horizSectorCross;

      // line rows
      if (isLineRow(row)) {
        // sector divider rows characters
        if (isSectorBorderRow(row)) {
          leftVert = Char.l2h2;
          rightVert = Char.r2h2;
          horizLine = Char.h2;
          horizNodeCross = Char.c2v1;
          horizSectorCross = Char.c2;
        // node divider rows characters
        } else {
          leftVert = Char.l2h1;
          rightVert = Char.r2h1;
          horizLine = Char.h1;
          horizNodeCross = Char.c1;
          horizSectorCross = Char.c2h1;
        }
        // print line row
        canvas.write(leftVert);
        for (var col = 1; col < 36; col++) {
          isSectorBorderCol(col) ?
          canvas.write(horizSectorCross) :
          isLineCol(col) ?
          canvas.write(horizNodeCross) :
          canvas.write(horizLine);
        }
        canvas.write(rightVert);
      // non-line rows
      } else {
        leftVert = Char.v2;
        rightVert = Char.v2;
        late String vertLine;

        canvas.write(leftVert);
        // line columns
        for (var col = 1; col < 36; col++) {
          if (isLineCol(col)) {
            if (isSectorBorderCol(col)) {
              vertLine = Char.v2;
            } else {
              vertLine = Char.v1;
            }
          } else {
            vertLine = '•';
          }
          canvas.write(vertLine);
        }
        canvas.write(rightVert);
      }
      canvas.write('\n');
    }

    // print bottom border
    canvas.write('${Char.bl2}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.b2v2}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.b2v2}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.b2v1}${Char.h2}${Char.h2}${Char.h2}${Char.br2}\n');
  }

  void writeSheet(Sheet sheet) {
    writeSheetBorders();
    var sheetNodePresenter = SheetNodePresenter(canvas);

    // for each SheetNode in Sheet, print the SheetNode on the canvas
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        sheetNodePresenter.writeSheetNode(sheetNode: sheet.rows[i][j], x: j*3+j+1, y: i*3+i+1);
      }
    }
  }

  void printCanvas () => print(canvas);

}

void writeSheet(Sheet sheet) {
  printSheetBorders();
  var sheetNodePresenter = SheetNodePresenter();

  // for each SheetNode in Sheet, print the SheetNode on the canvas
  for (var i = 0; i < 9; i++) {
    for (var j = 0; j < 9; j++) {
      sheetNodePresenter.writeSheetNode(sheetNode: sheet.rows[i][j], x: j*3+j+1, y: i*3+i+1);
    }
  }

  printCanvasInfo(sheet);
}

void printCanvasInfo(sheet) {
  stdout.write(sheet.rows[0][0].solutions);
  stdout.write('\n');
  print('terminal rows: ${stdout.terminalLines}');
  print('terminal columns: ${stdout.terminalColumns}');
  print(sheet);
  print('done');
}

void printSheetBorders() {
  stdout.write(ansiEscapes.clearScreen);
  // print top border
  stdout.write('${Char.tl2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v2}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.t2v1}${Char.h2}${Char.h2}${Char.h2}${Char.tr2}\n');

  // print rows
  for (var row = 1; row < 36; row++) {

    late final String leftVert;
    late final String rightVert;
    late final String horizLine;
    late final String horizNodeCross;
    late final String horizSectorCross;

    // line rows
    if (isLineRow(row)) {
      // sector divider rows characters
      if (isSectorBorderRow(row)) {
        leftVert = Char.l2h2;
        rightVert = Char.r2h2;
        horizLine = Char.h2;
        horizNodeCross = Char.c2v1;
        horizSectorCross = Char.c2;
      // node divider rows characters
      } else {
        leftVert = Char.l2h1;
        rightVert = Char.r2h1;
        horizLine = Char.h1;
        horizNodeCross = Char.c1;
        horizSectorCross = Char.c2h1;
      }

      // print line row
      stdout.write(leftVert);
      for (var col = 1; col < 36; col++) {
        isSectorBorderCol(col) ?
          stdout.write(horizSectorCross) :
          isLineCol(col) ?
            stdout.write(horizNodeCross) :
            stdout.write(horizLine);
      }
      stdout.write(rightVert);
      // stdout.write('\n');

    } else {
      leftVert = Char.v2;
      rightVert = Char.v2;
      late String vertLine;

      stdout.write(leftVert);
      // line columns
      for (var col = 1; col < 36; col++) {
        if (isLineCol(col)) {
          if (isSectorBorderCol(col)) {
            vertLine = Char.v2;
          } else {
            vertLine = Char.v1;
          }
        } else {
          vertLine = '•';
        }
        stdout.write(vertLine);
      }
      stdout.write(rightVert);
    }
    // the \n character makes stdout print its buffer and then a new line
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
  return row % 12 == 0;
}

bool isLineCol(int col) {
  // total cols (within top and bottom borders):  37
  // line col indices (cols are 1-indexed): 4, 8, 12, 16, 20, 24, 28, 32, 36
  return col % 4 == 0;
}

bool isSectorBorderCol(int col) {
  // every 12th col (every 3rd border col) is a sector border
  return col % 12 == 0;
}


void main() {
  var sheetInitializer = SheetInitializer();
  var sheet = Sheet(sheetInitializer);
  var canvas = StringBuffer();

  var sheetPresenter = SheetPresenter(canvas);

  sheetPresenter.writeSheet(sheet);
  sheetPresenter.printCanvas();

  print('\ncodeUnits:\n');

  print(sheetPresenter.canvas.toString().codeUnits);
}
