# Dart Sudoku

A simple command-line Dart application for solving Sudoku puzzles.

## Test

### run all tests:
- line by line:
`dart test --reporter=expanded`
- single line:
`dart test --reporter=compact`

### run test(s) based on name:
`dart test --name sheet [--name main]`

### run single test based on filename:
`dart test/lib/src/domain/entities/sheet_test.dart`

### coverage
- install lcov on Mac:

`brew install lcov`

- activate coverage and install `collect_coverage` and `format_coverage` executables:

`dart pub global activate coverage`

- generate lcov.info file (report on lib only)

`dart pub global run coverage:format_coverage --packages=.packages --report-on=lib --lcov -o ./test_coverage/lcov.info -i ./test_coverage`

- generate coverage reports (this step must be reapeated each time
you wish to generate a fresh report):

`genhtml test_coverage/lcov.info -o test_coverage`

This will generate `test_coverage/index.html` – open this file in a web browser to view coverage reports.
