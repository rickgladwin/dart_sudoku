// main application entrypoint


import 'dart:io';

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/usecases/sheet_solver.dart';
import 'package:dart_sudoku/src/interaction/sheet_importer.dart';
import 'package:dart_sudoku/src/service/presenters/sheet_presenter.dart';

import 'domain/entities/sheet_solve_result.dart';

Future<void> main(List<String> args) async {
  String puzzleFile = 'sudoku_easy_1.sdk';

  print("Dart sudoku solver");

  // import puzzle
  print('enter .sdk file to solve (default sudoku_easy_1.sdk)');
  var input = stdin.readLineSync().toString();

  if (input.isNotEmpty) {
    puzzleFile = input;
  }

  var sheetImporter = SheetImporter();
  Sheet sheet;
  try {
    sheet = await sheetImporter.importToSheet(fileName: puzzleFile);
  } catch (e) {
    print('Sorry, could not validate that puzzle file: $e');
    exit(0);
  }

  // solve puzzle
  var sheetSolver = SheetSolver(sheet);
  var result = await sheetSolver.solve();

  // display results
  if (result.finalStatus == FinalStatus.solved) {
    print('Done! Solution is:');
  } else {
    print('Dang! This one is unsolvable:');
  }

  var sheetPresenter = SheetPresenter();
  sheetPresenter.writeSheet(result.finalSheet);
  print(sheetPresenter.canvas);

  exit(0);
}
