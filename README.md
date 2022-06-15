# Dart Sudoku

A simple command-line Dart application for solving Sudoku puzzles.

Uses basic elimination methods until a solution is found or these methods
no longer yield changes, then applies brute force recursion to the remaining
puzzle if it is unsolved.

![coverage: 100%](https://img.shields.io/badge/coverage-100%25-green) ![version: 0.1](https://img.shields.io/badge/version-0.1-blue)

## Architecture

Folder structure implements a version of Robert Martin's Clean Architecture pattern,
which follows the basic layers (parent bullet points represent inner layers first):
- Enterprise Business Rules
  - Entities
- Application Business Rules
  - Use Cases
- Interface Adapters
  - Controllers
  - Gateways
  - Presenters
- Frameworks & Drivers
  - Devices
  - Web
  - DB
  - UI
  - External Interfaces

Dependencies always point inward (upward, in this bulleted list).

Folder structure under the `src` folder, in addition to `config` etc.,
collects the Clean Architecture layers in the following way:

- domain
  - Enterprise Business Rules
  - Application Business Rules
- service
  - Interface Adapters
- interaction
  - Frameworks & Drivers

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

- generate lcov.info file and coverage.json ~~(report on lib only)~~

~~`dart pub global run coverage:format_coverage --packages=.packages --report-on=lib --lcov -o ./test_coverage/lcov.info -i ./test_coverage`~~

OR

`dart pub global run coverage:test_with_coverage -o ./test_coverage`

- generate coverage reports (this step must be repeated each time
you wish to generate a fresh report):

`genhtml test_coverage/lcov.info -o test_coverage`

This will generate `test_coverage/index.html` – open this file in a web browser to view coverage reports.
