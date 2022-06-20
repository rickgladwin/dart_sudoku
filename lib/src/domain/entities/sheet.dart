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
  get columns {
    return getColumns();
  }

  Sheet(SheetInitializer rowData) {
    rows = rowData.rows;
  }

  List<List<SheetNode>> getColumns() {
    // build a null 9x9 array
    List<List<SheetNode>> columnData = [];
    for (var i = 0; i < 9; i++) {
      var columnNull = [for (var i = 0; i < 9; i++) SheetNode({})];
      columnData.add(columnNull);
    }

    // fill the array using a nested loop over rows (invert Sheet.rows)
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        columnData[i][j] = rows[j][i];
      }
    }
    return columnData;
  }
}

class SheetInitializer {
  // rows is a list of lists of SheetNodes, comprising the Sheet
  late List<List<SheetNode>> rows = [];
  // columns is the result of a function that iterates over all rows
  //  and gets the SheetNode at an index in each row, building a
  //  new list of lists of SheetNodes (rows, rotated 90º)

  SheetInitializer({List<List<SheetNode?>>? rowData}) {
    if (rowData == null) {
      initializeDefaultSheet();
    } else {
      initializeSheetWithData(rowData);
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

  void initializeSheetWithData(List<List<SheetNode?>> rowData) {
    for (var i = 0; i < 9; i++) {
      rows.add([]);
      for (var j = 0; j < 9; j++) {
        if (rowData[i][j].runtimeType != SheetNode) {
          rows[i].add(SheetNode());
          continue;
        }
        rows[i].add(rowData[i][j] as SheetNode);
      }
    }
  }
}
