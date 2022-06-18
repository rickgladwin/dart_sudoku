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

          // start the app in its own process
          final process = await Process.start('dart', [mainPath]);
          final lineStream = process.stdout
              .transform(const Utf8Decoder())
              .transform(const LineSplitter());

          // (hit enter)
          process.stdin.writeln();

          // read output
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
        test('solves medium puzzle', () async {

          // start the app in its own process
          final process = await Process.start('dart', [mainPath]);
          final lineStream = process.stdout
              .transform(const Utf8Decoder())
              .transform(const LineSplitter());

          // (enter medium puzzle filename)
          process.stdin.writeln('sudoku_medium_1.sdk');

          // read output
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


          expect(lineStreamQuickHashBuffer.toString().contains(KnownGood.mediumSolvedPuzzleQuickHash), true);

        });
      });
      group('HARD:', () {
        test('solves hard puzzle', () async {

          // start the app in its own process
          final process = await Process.start('dart', [mainPath]);
          final lineStream = process.stdout
              .transform(const Utf8Decoder())
              .transform(const LineSplitter());

          // (enter medium puzzle filename)
          process.stdin.writeln('sudoku_hard_1.sdk');

          // read output
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


          expect(lineStreamQuickHashBuffer.toString().contains(KnownGood.hardSolvedPuzzleQuickHash), true);

        });
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
  
  static String mediumSolvedPuzzle = '''
╔═══╤═══╤═══╦═══╤═══╤═══╦═══╤═══╤═══╗
║   │   │   ║   │   │   ║   │   │   ║
║ 6 │ 4 │ 9 ║ 3 │ 1 │ 8 ║ 5 │ 2 │ 7 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 5 │ 3 │ 1 ║ 7 │ 2 │ 6 ║ 8 │ 9 │ 4 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 8 │ 2 │ 7 ║ 4 │ 9 │ 5 ║ 1 │ 6 │ 3 ║
║   │   │   ║   │   │   ║   │   │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║   │   │   ║   │   │   ║   │   │   ║
║ 4 │ 9 │ 6 ║ 5 │ 7 │ 1 ║ 3 │ 8 │ 2 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 7 │ 5 │ 3 ║ 8 │ 4 │ 2 ║ 9 │ 1 │ 6 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 2 │ 1 │ 8 ║ 9 │ 6 │ 3 ║ 4 │ 7 │ 5 ║
║   │   │   ║   │   │   ║   │   │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║   │   │   ║   │   │   ║   │   │   ║
║ 9 │ 6 │ 2 ║ 1 │ 5 │ 4 ║ 7 │ 3 │ 8 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 1 │ 8 │ 5 ║ 6 │ 3 │ 7 ║ 2 │ 4 │ 9 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 3 │ 7 │ 4 ║ 2 │ 8 │ 9 ║ 6 │ 5 │ 1 ║
║   │   │   ║   │   │   ║   │   │   ║
╚═══╧═══╧═══╩═══╧═══╧═══╩═══╧═══╧═══╝
''';
  
  static String mediumSolvedPuzzleQuickHash = '649318527531726894827495163496571382753842916218963475962154738185637249374289651';
  
  static String hardSolvedPuzzle = '''
╔═══╤═══╤═══╦═══╤═══╤═══╦═══╤═══╤═══╗
║   │   │   ║   │   │   ║   │   │   ║
║ 8 │ 5 │ 6 ║ 1 │ 3 │ 2 ║ 4 │ 7 │ 9 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 3 │ 4 │ 7 ║ 5 │ 9 │ 8 ║ 1 │ 6 │ 2 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 1 │ 9 │ 2 ║ 7 │ 6 │ 4 ║ 5 │ 3 │ 8 ║
║   │   │   ║   │   │   ║   │   │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║   │   │   ║   │   │   ║   │   │   ║
║ 2 │ 6 │ 9 ║ 8 │ 7 │ 1 ║ 3 │ 4 │ 5 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 5 │ 1 │ 8 ║ 3 │ 4 │ 9 ║ 7 │ 2 │ 6 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 7 │ 3 │ 4 ║ 2 │ 5 │ 6 ║ 8 │ 9 │ 1 ║
║   │   │   ║   │   │   ║   │   │   ║
╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣
║   │   │   ║   │   │   ║   │   │   ║
║ 6 │ 8 │ 5 ║ 4 │ 2 │ 7 ║ 9 │ 1 │ 3 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 4 │ 2 │ 3 ║ 9 │ 1 │ 5 ║ 6 │ 8 │ 7 ║
║   │   │   ║   │   │   ║   │   │   ║
╟───┼───┼───╫───┼───┼───╫───┼───┼───╢
║   │   │   ║   │   │   ║   │   │   ║
║ 9 │ 7 │ 1 ║ 6 │ 8 │ 3 ║ 2 │ 5 │ 4 ║
║   │   │   ║   │   │   ║   │   │   ║
╚═══╧═══╧═══╩═══╧═══╧═══╩═══╧═══╧═══╝
''';
  
  static String hardSolvedPuzzleQuickHash = '856132479347598162192764538269871345518349726734256891685427913423915687971683254';

}