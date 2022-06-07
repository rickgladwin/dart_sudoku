import 'dart:io';
import 'package:dart_sudoku/src/domain/entities/sheet.dart';

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

void printSheet() {
  stdout.write('printing sheet');
  const int charCode = 2560;
  stdout.writeCharCode(charCode);
  print('printing!!!');
  print(Char.r2h1);
  print(Char.r2h1);
  print(Char.r2h1);
  stdout.write('thing1');
  stdout.writeln('thing');
  stdout.done;
  print('terminal rows: ${stdout.terminalLines}');
  print('terminal columns: ${stdout.terminalColumns}');
  print('done');
}