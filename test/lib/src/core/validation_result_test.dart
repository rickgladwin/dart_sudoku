// unit tests for validation_result objects

import 'package:dart_sudoku/src/core/validation_result.dart';
import 'package:test/test.dart';

void main() {
  group('ValidationResult', () {
    test('initializes with blank message by default', () {
      var validationResult = ValidationResult();
      expect(validationResult.message, equals(''));
    });

    test('initializes with custom message', () {
      const initMessage = 'custom validation message';
      var validationResult = ValidationResult(message: initMessage);
      expect(validationResult.message, equals(initMessage));
    });

    test('initializes with false status by default', () {
      var validationResult = ValidationResult();
      expect(validationResult.status, equals(false));
    });

    test('initializes with custom boolean true', () {
      const initStatus = true;
      var validationResult = ValidationResult(status: initStatus);
      expect(validationResult.status, equals(initStatus));
    });

    test('initializes with custom boolean false', () {
      const initStatus = false;
      var validationResult = ValidationResult(status: initStatus);
      expect(validationResult.status, equals(initStatus));
    });
  });
}
