// main application entrypoint
import 'package:collection/collection.dart';


void main(List<String> args) {
  var listEquals = ListEquality().equals;
  // print("hello world");

  // buffer comparison
  var buffer1 = StringBuffer();
  var buffer2 = StringBuffer();

  for (var i = 0; i < 5; i++) {
    buffer1.write('hello');
    buffer2.write('hello');
  }

  print(buffer1);
  print(buffer1.toString());
  print(buffer1.toString().runes);

  // log(buffer1.toString().runes.toString());
  print('\n');
  print(buffer1.toString().codeUnits);
  print('\n');
  print(buffer2.toString().codeUnits);
  print('\n');

  // false
  print(buffer1 == buffer2);
  // true
  print(buffer1.toString() == buffer2.toString());
  // false
  print(identical(buffer1.toString(), buffer2.toString()));
  // false
  print(identical(buffer1, buffer2));
  // false
  print(buffer1.toString().codeUnits == buffer2.toString().codeUnits);
  // false
  print(buffer1.toString().runes == buffer2.toString().runes);
  // false
  print(identical(buffer1.toString().codeUnits, buffer2.toString().codeUnits));
  // true
  print(listEquals(buffer1.toString().codeUnits, buffer2.toString().codeUnits));
  // true
  print(identical(buffer1.toString().codeUnits[2], buffer2.toString().codeUnits[2]));
  // true
  print(buffer1.toString().codeUnits[2] == buffer2.toString().codeUnits[2]);

}
