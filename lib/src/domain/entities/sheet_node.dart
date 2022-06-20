// 9 x 9 SheetNodes represents a Sudoku Sheet
// holds the data about the possible solutions at its
// position on the Sheet

class SheetNode {
  late Set<int> solutions;

  SheetNode([Set<int>? solutions]) {
    this.solutions = solutions ?? <int>{1,2,3,4,5,6,7,8,9};
  }
}
