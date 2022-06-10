// acceptance tests etc. for main

import 'package:test/test.dart';

void main() {
  group('Main:', () => {
    group('EASY:', () {
      test('solves easy puzzle', () {}, skip: 'TODO: fulfill acceptance criteria for easy puzzle');
    }),
    group('MEDIUM:', () {
      test('solves medium puzzle', () {}, skip: 'TODO: fulfill acceptance criteria for medium puzzle');
    }),
    group('HARD:', () {
      test('solves hard puzzle', () {}, skip: 'TODO: fulfill acceptance criteria for hard puzzle');
    }),
  });
}