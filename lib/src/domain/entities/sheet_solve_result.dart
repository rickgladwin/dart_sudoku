// sheet solution result object

import 'package:dart_sudoku/src/domain/entities/sheet.dart';

class SheetSolveResult {
  late FinalStatus finalStatus;
  late Sheet finalSheet;
}

/// solved, unsolved, unsolvable
enum FinalStatus {solved, unsolved, unsolvable}
