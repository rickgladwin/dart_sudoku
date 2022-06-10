import 'package:test/test.dart';

void main() {
  group('Canvas:', () {
    group('Write to Canvas', () {
      test('stores a string to canvas', () {
        var canvas = Canvas();
      }, skip: 'TODO: add append to canvas method');
      test('stores a sequence of strings to canvas', () {}, skip: 'TODO: test append method');
      test('stores a sequence of character control codes to canvas', () {}, skip: 'TODO: test append method');
    });
    group('Print Canvas to console', () {
      test('prints string canvas content to console', () {}, skip: 'TODO: add print to console method');
      test('prints character code canvas content to console', () {}, skip: 'TODO: test print to console method for char codes');
      test('prints character control code canvas content to console', () {}, skip: 'TODO: test print to console method for control codes');
    });
  });
}