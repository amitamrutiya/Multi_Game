import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List> operate(List<int> row, int score, SharedPreferences sharedPref,
    int userInputRow, int userInputCol, bool music) async {
  row = slide(row, userInputRow);
  List result =
      await combine(row, score, sharedPref, userInputRow, userInputCol, music);
  int sc = result[0];
  row = result[1];
  row = slide(row, userInputRow);

  print('from func $sc');
  return [sc, row];
}

List<int> filter(List<int> row) {
  List<int> temp = [];
  for (int i = 0; i < row.length; i++) {
    if (row[i] != 0) {
      temp.add(row[i]);
    }
  }
  return temp;
}

List<int> slide(List<int> row, int userInputRow) {
  List<int> arr = filter(row);
  int missing = userInputRow - arr.length;
  List<int> zeroes = zeroArray(missing);
  arr = zeroes + arr;
  return arr;
}

List<int> zeroArray(int length) {
  List<int> zeroes = [];
  for (int i = 0; i < length; i++) {
    zeroes.add(0);
  }
  return zeroes;
}

Future<List> combine(List<int> row, int score, SharedPreferences sharedPref,
    int userInputRow, int userInputCol, bool music) async {
  final player = AudioPlayer();
  for (int i = userInputRow - 1; i >= 1; i--) {
    int a = row[i];
    int b = row[i - 1];
    if (a == b) {
      row[i] = a + b;
      if (music) {
        switch (row[i]) {
          case 4:
            await player.play(AssetSource('music/2048/4.mp3'));
            break;
          case 8:
            await player.play(AssetSource('music/2048/8.mp3'));
            break;
          case 16:
            await player.play(AssetSource('music/2048/16.mp3'));
            break;
          case 32:
            await player.play(AssetSource('music/2048/32.mp3'));
            break;
          case 64:
            await player.play(AssetSource('music/2048/64.mp3'));
            break;
          case 128:
            await player.play(AssetSource('music/2048/128.mp3'));
            break;
          case 256:
            await player.play(AssetSource('music/2048/256.mp3'));
            break;
          case 512:
            await player.play(AssetSource('music/2048/512.mp3'));
            break;
          case 1028:
            await player.play(AssetSource('music/2048/1024.mp3'));
            break;
          case 2048:
            await player.play(AssetSource('music/2048/2048.mp3'));
            break;
          case 4096:
            await player.play(AssetSource('music/2048/4096.mp3'));
            break;
        }
      }
      score += row[i];
      int? sc = sharedPref.getInt('high_score$userInputRow$userInputCol');
      if (sc == null) {
        sharedPref.setInt('high_score$userInputRow$userInputCol', score);
      } else {
        if (score > sc) {
          sharedPref.setInt('high_score$userInputRow$userInputCol', score);
        }
      }
      row[i - 1] = 0;
    }
  }

  // await player.dispose();
  return [score, row];
}

bool isGameWon(List<List<int>> grid, int userInputRow, int userInputCol) {
  for (int i = 0; i < userInputRow; i++) {
    for (int j = 0; j < userInputCol; j++) {
      if (grid[i][j] == 2048) {
        return true;
      }
    }
  }
  return false;
}

bool isGameOver(List<List<int>> grid, int userInputRow, int userInputCol) {
  for (int i = 0; i < userInputRow; i++) {
    for (int j = 0; j < userInputCol; j++) {
      if (grid[i][j] == 0) {
        return false;
      }
      if (i != userInputRow - 1 && grid[i][j] == grid[i + 1][j]) {
        return false;
      }
      if (j != userInputCol - 1 && grid[i][j] == grid[i][j + 1]) {
        return false;
      }
    }
  }
  return true;
}
