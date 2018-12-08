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
  
  // Move boid i from the old location, o, to the new location, n.
  void move(int[] o, int[] n, Integer i) {
    cells[o[0]][o[1]].remove(i);
    cells[n[0]][n[1]].add(i);
  }
  
  class Cell {
    ArrayList<Integer> list;
    
    Cell() {
      list = new ArrayList<Integer>();
    }
    
    void remove(Integer i) {
      list.remove(i);
    }
    
    void add(Integer i) {
      list.add(i);
    }
  }
}
