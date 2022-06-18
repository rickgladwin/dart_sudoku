// acceptance tests etc. for main
@TestOn('vm')

import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';


final String mainPath = 'lib/src/main.dart';

void main() {
  group('Main:', () {
    group('Solves Puzzles:', () {
      group('EASY:', () {
        test('solves easy puzzle', () async {
          final process = await Process.start('dart', [mainPath]);
          final lineStream = process.stdout
              .transform(const Utf8Decoder())
              .transform(const LineSplitter());

          // (hit enter)
          process.stdin.writeln();

          var lineStreamBuffer = StringBuffer();

          await for (final line in lineStream) {
            print(line);
            lineStreamBuffer.write(line);
          }

          final matches = filterOutNonNumbers(inputString: lineStreamBuffer.toString());

          var lineStreamQuickHashBuffer = StringBuffer();

          for (var match in matches) {
            lineStreamQuickHashBuffer.write(match[0]);
          }


          expect(lineStreamQuickHashBuffer.toString().contains(KnownGood.easySolvedPuzzleQuickHash), true);

        });
      });
      group('MEDIUM:', () {
        test('solves medium puzzle', () {}, skip: 'TODO: fulfill acceptance criteria for medium puzzle');
      });
      group('HARD:', () {
        test('solves hard puzzle', () {}, skip: 'TODO: fulfill acceptance criteria for hard puzzle');
      });
    });
  });
}

Iterable<RegExpMatch> filterOutNonNumbers({required inputString}) {
  final nonNumbersRegex = RegExp(r'\d');
  return nonNumbersRegex.allMatches(inputString);
}


class KnownGood {
  static String easySolvedPuzzle = '''
╔═══╤═══╤═══╦═══╤═══╤═══╦═══╤═══╤═══╗
║   │   │   ║   │   │   ║   │   │   ║
║ 2 │ 1 │ 9 ║ 7 │ 6 │ 4 ║ 5 │ 3 │ 8 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 6 │ 8 │ 5 ║ 1 │ 3 │ 2 ║ 4 │ 7 │ 9 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 7 │ 3 │ 4 ║ 5 │ 9 │ 8 ║ 1 │ 6 │ 2 ║
║   │   │   ║   │   │   ║   │   │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║   │   │   ║   │   │   ║   │   │   ║
║ 1 │ 9 │ 7 ║ 6 │ 8 │ 3 ║ 2 │ 5 │ 4 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 3 │ 4 │ 2 ║ 9 │ 1 │ 5 ║ 6 │ 8 │ 7 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 5 │ 6 │ 8 ║ 4 │ 2 │ 7 ║ 9 │ 1 │ 3 ║
║   │   │   ║   │   │   ║   │   │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║   │   │   ║   │   │   ║   │   │   ║
║ 8 │ 5 │ 1 ║ 3 │ 4 │ 9 ║ 7 │ 2 │ 6 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 4 │ 7 │ 3 ║ 2 │ 5 │ 6 ║ 8 │ 9 │ 1 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 9 │ 2 │ 6 ║ 8 │ 7 │ 1 ║ 3 │ 4 │ 5 ║
║   │   │   ║   │   │   ║   │   │   ║
╚═══╧═══╧═══╩═══╧═══╧═══╩═══╧═══╧═══╝
''';
  
  static String easySolvedPuzzleQuickHash = '219764538685132479734598162197683254342915687568427913851349726473256891926871345';

}