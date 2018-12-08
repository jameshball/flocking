class Grid {
  Cell[][] cells;
  int rows, cols;
  
  Grid(int x, int y) {
    cells = new Cell[x][y];
    
    rows = x;
    cols = y;
    
    for (int i = 0; i < x; i++) {
      for (int j = 0; j < y; j++) {
        cells[i][j] = new Cell();
      }
    }
  }
  
  class Cell {
    List<Integer> list;
    
    Cell() {
      list = new ArrayList<Integer>();
    }
    
    void add(int i) {
      list.add(i); //<>//
    }
  }
}
