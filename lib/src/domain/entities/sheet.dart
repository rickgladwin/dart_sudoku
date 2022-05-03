// the data object that represents the sudoku puzzle
// from initialization/import to solution/export

// requirements:
//  - 9 nodes x 9 nodes
//  - can be initialized with nodes
//  - indexable by row and column to target a solved/unsolved node

// try:
//  - List of Lists of SheetNodes

import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';

class Sheet {
  late List<List<SheetNode>> rows;
  // TODO: make columns a getter
  // late List<SheetNode> columns;

  Sheet(SheetInitializer rowData) {
    rows = rowData.rows;
  }
}

class SheetInitializer {
  // rows is a list of lists of SheetNodes, comprising the Sheet
  late List<List<SheetNode>> rows = [];
  // columns is the result of a function that iterates over all rows
  //  and gets the SheetNode at an index in each row, building a
  //  new list of lists of SheetNodes (rows, rotated 90º)
  // List<SheetNode> columns;

  SheetInitializer({List<List<SheetNode>>? rowData}) {
    if (rowData == null) {
      initializeDefaultSheet();
    }
  }

  void initializeDefaultSheet() {
    for (var i = 0; i < 9; i++) {
      rows.add([]);
      for (var j = 0; j < 9; j++) {
        rows[i].add(SheetNode());
      }
    }
  }
}
