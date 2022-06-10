import 'package:test/test.dart';


main() {
  group('Eliminate Solutions', () {

    test('finds a solved node', () {

    }, skip: 'TODO: build solved node finder');

    test('finds all solved nodes', () {

    }, skip: 'find/track all solved nodes');

    test('eliminates solutions across a row', () {

    }, skip: 'TODO: seek and remove solutions in the same row as a solved node');

    test('eliminate solutions in a column', () {

    }, skip: 'TODO: seek and remove solutions in the same column as a solved node');

    test('eliminate solutions in sector', () {

    }, skip: 'TODO: seek and remove solutions in the same sector as a solved node');
  });

  group('Evaluate Sheet', () {
    test('stops if the sheet is solved', () {

    }, skip: 'TODO: stop if the sheet is solved (a higher abstract than checking in the handler)');

    test('halts if the sheet cannot be solved', () {

    }, skip: 'TODO: create halting logic/conditions');
  });
}