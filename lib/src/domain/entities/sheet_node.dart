// 9 x 9 SheetNodes represents a Sudoku Sheet
// holds the data about the possible solutions at its current
//  position on the Sheet, (and its solved/unsolved status? Or is that
//  up to an interpreter? Do we make the SheetNode responsible for what its
//  own data MEANS, or is it just responsible for holding the data and
//  structure? Maybe that's the responsibility of usecases.)

class SheetNode {
  // List<int> solutions = <int>[1,2,3,4,5,6,7,8,9];
  late List<int> solutions;
  SheetNode([List<int> solutions = const <int>[1,2,3,4,5,6,7,8,9]]) {
    this.solutions = solutions;
  }
}
