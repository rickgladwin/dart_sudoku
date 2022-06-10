import 'dart:io';

import 'package:ansi_escapes/ansi_escapes.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';
import 'package:dart_sudoku/src/presentation/presenters/sheet_node_presenter.dart';
import 'package:test/test.dart';

class KnownGood {
  static const defaultSheetNode = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9']
  ];
}

void main() {
  group('SheetNodePresenter', () {
    test('presents a default SheetNode', () async {
      // final stdoutStream = stdout.addStream(stream)
      // var stdOutStream = Stream.listen();
      // stdin.readLineSync();
      // TODO: capture console output (stdout) as a stream, compare that stream
      //  with a Known Good.

      stdout.write(ansiEscapes.clearScreen);
      var sheetNode = SheetNode();
      printSheetNode(sheetNode: sheetNode, x: 0, y: 0);
      stdout.write('\n\n\n\n');
      sleep(Duration(seconds: 2));
      // read canvas
      stdout.write(ansiEscapes.curserTo(0, 0));
      var checkChar = await stdin.elementAt(2);
      stdout.write('\n');
      print(checkChar);
      print('okay');
    }, skip: 'create "known good" printed sheet node checker');
    // });
  });
}
