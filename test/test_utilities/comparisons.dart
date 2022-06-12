// methods to compare objects

import 'package:collection/collection.dart';
import 'package:dart_sudoku/src/domain/entities/sheet.dart';

bool bufferEqual (StringBuffer buffer1, StringBuffer buffer2) {
  var listEqual = ListEquality().equals;
  return listEqual(buffer1.toString().codeUnits, buffer2.toString().codeUnits);
}

bool bufferEqualsCodeUnits (StringBuffer buffer, List<int> codeUnits) {
  var listEqual = ListEquality().equals;
  var bufferCodeUnits = buffer.toString().codeUnits;
  return listEqual(bufferCodeUnits, codeUnits);
}

bool sheetEqual ({required Sheet sheet1, required Sheet sheet2}) {
  for (var i = 0; i < 9; i ++) {
    for (var j = 0; j < 9; j ++) {
      var solutions1 = sheet1.rows[i][j].solutions;
      var solutions2 = sheet2.rows[i][j].solutions;
      if (solutions1.length != solutions2.length || !solutions1.every(solutions2.contains)) {
        return false;
      }
    }
  }

  return true;
}
