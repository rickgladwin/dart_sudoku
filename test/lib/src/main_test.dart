// acceptance tests etc. for main

import 'package:test/test.dart';

void main() {
  group('Main:', () => {
    group('Solves easy puzzles:', () {
      test('solves easy puzzle', () {}, skip: 'TODO: fulfill acceptance criteria for easy puzzle');
    }),
    group('Solves medium puzzles:', () {
      test('solves medium puzzle', () {}, skip: 'TODO: fulfill acceptance criteria for medium puzzle');
    }),
    group('Solves hard puzzles:', () {
      test('solves hard puzzle', () {}, skip: 'TODO: fulfill acceptance criteria for hard puzzle');
    })
  });
}