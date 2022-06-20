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
          .transform(const Utf8Decoder(allowMalformed: true))
          .transform(const LineSplitter());

          // (hit enter)
          process.stdin.writeln();

          // read output
          var lineStreamBuffer = StringBuffer();

          var lineStreamList = [];

          var filterCodeUnits = '123456789'.codeUnits;

          print('^^^');
          print('9: \u0057 – ${String.fromCharCode(filterCodeUnits.last)}');
          print('^^^');

          // var topLine = '╔═══╤═══╤═══╦═══╤═══╤═══╦═══╤═══╤═══╗';
          // var topLine = '╔';
          var topLine = KnownGood.easySolvedPuzzle;
          print('topLine: $topLine');
          var topLineCodes = topLine.codeUnits;
          var topLineRunes = topLine.runes;
          print('topLineCodes: $topLineCodes');
          print('topLineRunes: $topLineRunes');
          // var topLineBytes =
          // print(topLineCodes);
          print('topLineCodeChar from codeUnits: ${String.fromCharCode(topLineCodes.first)}');
          print('topLineCodeChars from codeUnits: ${String.fromCharCodes(topLineCodes)}');
          print('topLineCodeChar from runes: ${String.fromCharCode(topLineRunes.first)}');

          // var topLineCodes16 = encodeUtf16(topLine);
          const utf8Decoder = Utf8Decoder(allowMalformed: true);
          // const utf16Decoder = Utf16Decoder()
          var topLineDecoded = utf8Decoder.convert(topLineCodes);
          // var topLineDecoded16 =
          print('*** topLineDecoded:');
          print(topLineDecoded);
          print('^^^');

          print('filterCodeUnits: $filterCodeUnits');
          print('filterCodeUnits chars: ${String.fromCharCodes(filterCodeUnits)}');



          // await for (List<int> line in lineStream) {
          await for (var line in lineStream) {
            print('\n\n#### lineStream line: $line\n\n');
            // print('\n\n@@@@ lineStream line converted: ${String.fromCharCodes(line)}');
            // print('\n\n@@@@ lineStream line converted codes: ${String.fromCharCodes(line).codeUnits}');
            // print('\n\n#### line.length: ${line.length}');
            // print('\n\n#### KnownGood.easySolvedPuzzle: ${KnownGood.easySolvedPuzzle}');
            // print('\n\n#### KnownGood.easySolvedPuzzle.length: ${KnownGood.easySolvedPuzzle.length}');
            // print('\n\n#### lineStream line == KnownGood.easySolvedPuzzle: ${line == KnownGood.easySolvedPuzzle}');

            // compare
            // print(line.split(''));

            // Iterable<int> filteredLine = line.where((element) => element == 57);

            // print('\n\n^^^ filteredLine: $filteredLine');
            // print('\n\n^^^ filteredLine.length: ${filteredLine.length}');
            // print('\n\n!!! filteredLine chars: ${String.fromCharCodes(filteredLine)}');

            lineStreamBuffer.write(line);
            lineStreamList.add(line);
          }





          // print('#### lineStreamBuffer: ${lineStreamBuffer.toString()}');
          print('\n' * 30);
          print('\n\n#### lineStreamBuffer: $lineStreamBuffer');
          // print('#### lineStreamBuffer.runes: ${lineStreamBuffer.toString().runes}');
          // print('\n\n#### lineStreamBuffer.codeUnits: ${lineStreamBuffer.toString().codeUnits}');

          // print('\n\n%%%% lineStreamList: ${lineStreamList.toString()}');
          print('\n\n%%%% lineStreamList: $lineStreamList');
          // print('%%%% lineStreamList.runes: ${lineStreamList.toString().runes}');
          // print('\n\n%%%% lineStreamList.codeUnits: ${lineStreamList.toString().codeUnits}');
          print('\n' * 30);
          print('@@@@ lineStreamBuffer split: ${lineStreamBuffer.toString().split("")}');

          print('\n' * 30);
          print('@@@@ lineStreamBuffer: ${lineStreamBuffer.toString()}');

          var filteredLineStreamString = filterForSolutions(lineStreamBuffer.toString());
          print('\n' * 30);
          print('!!!!!!!!!!!!!! filteredLineStreamString: \n' + filteredLineStreamString);
          print('!!!!!!!!!!!!!! expectedQuickHash: \n' + KnownGood.easySolvedPuzzleQuickHash);

          // TODO: clean up code
          // TODO: apply the stdout filter to medium and hard puzzles

          expect(filteredLineStreamString.contains(KnownGood.easySolvedPuzzleQuickHash), true);

          var filteredQuickHash = StringBuffer();
          var unfilteredQuickHash = StringBuffer();
          var unfilteredQuickHash16 = StringBuffer();


          // for (List<int> elementList in lineStreamList) {
          //
          //   unfilteredQuickHash16.write(String.fromCharCodes(elementList));
          //
          //   for (int element in elementList) {
          //     // print('*** element: $element');
          //     // print('^^^ char:    ${String.fromCharCode(element)}');
          //
          //     unfilteredQuickHash.write(String.fromCharCode(element));
          //
          //     if (filterCodeUnits.contains(element)) {
          //       // print('!!!!!!!!!! passed filter !!!!!!!!!!');
          //       filteredQuickHash.write(String.fromCharCode(element));
          //       // print(String.fromCharCode(element));
          //       // sleep(Duration(milliseconds: 5));
          //     }
          //   }
          // }

          // for (List<int> elementList in lineStreamList) {
          //
          //   var elementCode = String.fromCharCodes(elementList);
          //
          //   unfilteredQuickHash16.write(String.fromCharCodes(elementList, 0, 16));
          //
          //   for (int element in elementList) {
          //     // print('*** element: $element');
          //     // print('^^^ char:    ${String.fromCharCode(element)}');
          //
          //     var elementChar = String.fromCharCode(element);
          //     // print('elementChar.length: ${elementChar.length}');
          //
          //     unfilteredQuickHash.write(String.fromCharCode(element));
          //
          //     if (filterCodeUnits.contains(element)) {
          //       // print('!!!!!!!!!! passed filter !!!!!!!!!!');
          //       filteredQuickHash.write(String.fromCharCode(element));
          //       // print(String.fromCharCode(element));
          //       // sleep(Duration(milliseconds: 5));
          //     }
          //   }
          // }

          print('\n\n#### ----------- ####');
          print('\n\nunfilteredQuickHash16: $unfilteredQuickHash16');
          print('\n\n#### ----------- ####');

          // quickHashRegEx = RegExp(r'2x1x9x7x6x4x5x3x8x6x8x5x1x3x2x4x7x9x7x3x4x5x9x8x1x6x2x1x9x7x6x8x3x2x5x4x3x4x2x9x1x5x6x8x7x5x6x8x4x2x7x9x1x3x8x5x1x3x4x9x7x2x6x4x7x3x2x5x6x8x9x1x9x2x6x8x7x1x3x4x5');
          var quickHashRegEx = RegExp(r'2.*1.*9.*7.*6.*4.*5.*3.*8.*6.*8.*5.*1.*3.*2.*4.*7.*9.*7.*3.*4.*5.*9.*8.*1.*6.*2.*1.*9.*7.*6.*8.*3.*2.*5.*4.*3.*4.*2.*9.*1.*5.*6.*8.*7.*5.*6.*8.*4.*2.*7.*9.*1.*3.*8.*5.*1.*3.*4.*9.*7.*2.*6.*4.*7.*3.*2.*5.*6.*8.*9.*1.*9.*2.*6.*8.*7.*1.*3.*4.*5');



          print('\n\nfilteredQuickHash ******************');
          print(filteredQuickHash);
          print('\n\n******************');

          print('\n\nunFilteredQuickHash ^^^^^^^^^^^^^^^^^');
          print(unfilteredQuickHash);
          print('\n\n^^^^^^^^^^^^^^^^^');

          print('KnownGood: ${KnownGood.easySolvedPuzzleQuickHash}');

          var justChars = StringBuffer();

          lineStreamBuffer.toString().runes.forEach((int rune) {
            // print(String.fromCharCode(rune));
            // print(rune);
            justChars.write(String.fromCharCode(rune));
          });

          // print('\n\n!!!!!! justChars: $justChars');



          print('\n\n123456789.codeUnits => $filterCodeUnits');

          // for (List<int> codeList in lineStreamList) {
          //   print('\n\ncodeList: $codeList\n\n');
          //   print('\n\ncodeList.length: ${codeList.length}\n\n');
          //
          //   print('\n\n************* unfiltered characters: ${String.fromCharCodes(codeList)}\n\n');
          //
          //   List<int> filteredCodeList = codeList.where((code) => filterCodeUnits.contains(code)).toList();
          //   print('filtered:\n');
          //   print('\n\nfilteredCodeList: $filteredCodeList\n\n');
          //   print('\n\nfilteredCodeList.length: ${filteredCodeList.length}\n\n');
          //
          //   print('------------ filtered characters:\n');
          //   print('\n\nfilteredCodeList: ${String.fromCharCodes(filteredCodeList)}\n\n');
          // }



          print('&&&&&&&&&');
          // print(lineStreamBuffer.toString().toString());
          // print(lineStreamBuffer.toString());
          print(lineStreamBuffer);
          var charBuffer = String.fromCharCodes(lineStreamBuffer.toString().codeUnits);

          print('lineStreamBuffer.length: ${lineStreamBuffer.length}');

          // print(lineStream.toString());
          print('&&&&&&&&&');

          // for (final char in lineStreamBuffer.toString().codeUnits) {
          //   print(char);
          // }

          print('\n\ncharBuffer: $charBuffer\n\n');

          // var filteredLineStreamBuffer = lineStreamBuffer.toString().codeUnits.where((unit) => filterCodeUnits.contains(unit)).toList();


          print('@@@@@@@@');
          // print('charBuffer: $charBuffer');
          // print('filteredLineStreamBuffer: $filteredLineStreamBuffer');
          // print('filteredLineStreamBuffer.length: ${filteredLineStreamBuffer.length}');
          print('@@@@@@@@');

          // var replacedResult = lineStreamBuffer.toString().replaceAll(RegExp(r'\D'), '');
          // var replacedResult = charBuffer.replaceAll(RegExp(r'\D'), '');
          var replacedResult = charBuffer.replaceAll(RegExp(r'[^12]'), '');
          // var replacedResult = String.fromCharCodes(lineStream).toString().replaceAll(RegExp(r'\D'), '');
          print('^^^^^^^^^^^^^');
          print(replacedResult);
          print('^^^^^^^^^^^^^');

          final matches = filterOutNonNumbers(inputString: lineStreamBuffer.toString());
          // final matches = filterOutNonNumbers(inputString: lineStreamBuffer);

          var lineStreamQuickHashBuffer = StringBuffer();

          for (var match in matches) {
            lineStreamQuickHashBuffer.write(match[0]);
          }

          print('@@@');
          print('1-9 codeUnits:');
          print('1 2 3 4 5 6 7 8 9'.codeUnits);
          print('filtered codeUnits:');

          print('number code units only: $filterCodeUnits');

          var testUnits = '1 2 3 4 5 6 7 8 9 a b c h # .'.codeUnits;
          // var filteredUnits = testUnits.where((unit) => unit.isEven).toList();
          var filteredUnits = testUnits.where((unit) => filterCodeUnits.contains(unit)).toList();

          print('testUnits: $testUnits');
          print('filteredUnits: $filteredUnits');





          print('@@@');

          print('*****');
          print(lineStreamQuickHashBuffer.toString());
          print('*****');
          print('KnownGood.easySolvedPuzzleQuickHash:');
          print(KnownGood.easySolvedPuzzleQuickHash.codeUnits);
          print('*****');


          // expect(lineStreamQuickHashBuffer.toString().contains(KnownGood.easySolvedPuzzleQuickHash), true);

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
          // final matches = filterOutNonNumbers(inputString: lineStreamBuffer);

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

/// filters out control codes (/\[.*H/), then filters
/// in [1-9] from a string.
String filterForSolutions (String input) {
  var splitString = input.split('');
  print('## splitString: $splitString');
  var filteredStringBuffer = StringBuffer();
  List solutions = ['1','2','3','4','5','6','7','8','9'];
  bool reject = false;
  for (final char in splitString) {
    if (char == 'H') {
      stdout.write('reject off-');
      reject = false;
      continue;
    }
    if (char == '[') {
      stdout.write('reject on-');
      reject = true;
      continue;
    }
    if (reject == false && solutions.contains(char)) {
    // if (reject == false) {
      stdout.write('keeping $char ');
      filteredStringBuffer.write(char);
    }
  }
  return filteredStringBuffer.toString();
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