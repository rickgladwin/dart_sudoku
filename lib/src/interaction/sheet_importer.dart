import 'package:dart_sudoku/src/core/helpers.dart';
import 'package:dart_sudoku/src/core/validation_result.dart';
import 'dart:io';
import 'dart:async';

import 'package:dart_sudoku/src/domain/entities/sheet.dart';
import 'package:dart_sudoku/src/domain/entities/sheet_node.dart';

class SheetImporter {

  late String puzzleData;
  String importDataPath = 'import_data/';

  Future<ValidationResult> validate ({required String dataFile}) async {
    var result = ValidationResult(status: false);
    if (getFileExtension(fileName: dataFile) == 'sdk') {
      await importFileContent(fileName: dataFile);
      result = validateSdkData(dataString: puzzleData);
    }
    return result;
  }

  ValidationResult validateSdkData ({required String dataString}) {
    var result = ValidationResult(status: true);

    // validate file header
    var sdkHeader = dataString.substring(0,9);
    if (sdkHeader != '[Puzzle]\n') {
      result.status = false;
      result.message = '"[Puzzle]" header missing from .sdk file';
      return result;
    }
    
    // validate file characters
    var sdkNodeData = dataString.substring(9);
    // everything but dots, digits, and newlines
    var invalidCharsRegex = RegExp(r'[^.\d\n]');
    if (invalidCharsRegex.hasMatch(sdkNodeData)) {
      result.status = false;
      result.message = '.sdk file contains disallowed characters';
      return result;
    }

    return result;
  }

  Future<void> importFileContent ({required fileName}) async {
    var puzzleFile = File(importDataPath + fileName);
    puzzleData = await puzzleFile.readAsString();
  }

  void cleanSDKFileData ({required String sdkFileData}) {
    // .sdk files begin with "[Puzzle]\n"
    // remove these first 9 characters
    puzzleData = sdkFileData.substring(9);
  }

  Sheet buildSheet({required String puzzleData}) {
    // build initializer data from puzzle data
    final charCodes = puzzleData.codeUnits;

    late List<List<SheetNode>> initializerData = [[],[],[],[],[],[],[],[],[]];

    var puzzleDataIndex = 0;
    late SheetNode currentNode;
    late String currentChar;

    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 10; j++) {
        if (j != 9) {
          currentChar = String.fromCharCode(charCodes[puzzleDataIndex]);
          currentNode = currentChar == '.' ? SheetNode() : SheetNode({int.parse(currentChar)});
          initializerData[i].add(currentNode);
        }
        ++puzzleDataIndex;
      }
    }

    // build initializer and sheet from initializer data
    return Sheet(SheetInitializer(rowData: initializerData));
  }

  Future<Sheet> importToSheet({required String fileName}) async {
    await importFileContent(fileName: fileName);

    // validate
    var fileIsValidResult = await validate(dataFile: fileName);
    if (fileIsValidResult.status == false) {
      throw Exception(fileIsValidResult.message);
    }

    // clean
    if (getFileExtension(fileName: fileName) == 'sdk') {
      cleanSDKFileData(sdkFileData: puzzleData);
    }
    // build
    return buildSheet(puzzleData: puzzleData);
  }
}
