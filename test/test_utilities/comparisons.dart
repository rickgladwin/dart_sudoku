// methods to compare objects

import 'package:collection/collection.dart';

bool bufferEqual (StringBuffer buffer1, StringBuffer buffer2) {
  var listEqual = ListEquality().equals;
  return listEqual(buffer1.toString().codeUnits, buffer2.toString().codeUnits);
}

bool bufferEqualsCodeUnits (StringBuffer buffer, List<int> codeUnits) {
  var listEqual = ListEquality().equals;
  var bufferCodeUnits = buffer.toString().codeUnits;
  return listEqual(bufferCodeUnits, codeUnits);
}