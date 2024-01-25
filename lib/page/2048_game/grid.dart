import 'point.dart';
import 'dart:math';

List<List<int>> blankGrid(int userInputRow, int userInputCol) {
  return List.generate(userInputRow, (_) => List.filled(userInputCol, 0));
}

bool compare(
    List<List<int>> a, List<List<int>> b, int userInputRow, int userInputCol) {
  for (int i = 0; i < userInputRow; i++) {
    for (int j = 0; j < userInputCol; j++) {
      if (a[i][j] != b[i][j]) {
        return false;
      }
    }
  }
  return true;
}

List<List<int>> copyGrid(
    List<List<int>> grid, int userInputRow, int userInputCol) {
  List<List<int>> extraGrid = blankGrid(userInputRow, userInputCol);
  for (int i = 0; i < userInputRow; i++) {
    for (int j = 0; j < userInputCol; j++) {
      extraGrid[i][j] = grid[i][j];
    }
  }
  return extraGrid;
}

List<List<int>> flipGrid(List<List<int>> grid, int userInputRow) {
  for (int i = 0; i < userInputRow; i++) {
    List<int> row = grid[i];
    grid[i] = row.reversed.toList();
  }
  return grid;
}

List<List<int>> transposeGrid(
    List<List<int>> grid, int userInputRow, int userInputCol) {
  List<List<int>> newGrid = blankGrid(userInputRow, userInputCol);
  for (int i = 0; i < userInputRow; i++) {
    for (int j = 0; j < userInputCol; j++) {
      newGrid[i][j] = grid[j][i];
    }
  }
  return newGrid;
}

List<List<int>> addNumber(
    List<List<int>> grid, int userInputRow, int userInputCol) {
  List<Point> options = [];
  bool is64 = false;
  bool is128 = false;
  for (int i = 0; i < userInputRow; i++) {
    for (int j = 0; j < userInputCol; j++) {
      if (grid[i][j] == 0) {
        options.add(Point(i, j));
      }
      if (grid[i][j] > 64) {
        is128 = true;
      } else if (grid[i][j] > 32) {
        is64 = true;
      }
    }
  }

  if (options.isNotEmpty) {
    int spotRandomIndex = Random().nextInt(options.length);
    Point spot = options[spotRandomIndex];
    int newvalue;
    int r = Random().nextInt(100);
    if (r > 90 && is128 == true) {
      newvalue = 16;
    } else if (r > 80 && is64 == true) {
      newvalue = 8;
    } else if (r > 50) {
      newvalue = 4;
    } else {
      newvalue = 2;
    }

    grid[spot.x][spot.y] = newvalue;
  }

  return grid;
}
