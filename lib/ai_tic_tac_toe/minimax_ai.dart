import 'dart:math';
import 'package:multi_game/ai_tic_tac_toe/get_winner_func.dart';

import 'package:multi_game/ai_tic_tac_toe/home_screen.dart';

class MiniMaxAI {
  GameMode gameMode;
  MiniMaxAI({required this.gameMode});
  int _miniMax(Map<int, Mark> board, int depth, bool isMaximizing) {
    Winner winner = getWinner(board)['winner'];

    // End state
    if (winner == Winner.tie) {
      return 0;
    } else if (winner != Winner.none) {
      return winner == Winner.x ? 100 : -100;
    }

    // Intermediate state
    int bestScore = isMaximizing ? -999 : 999;

    for (int i = 0; i < 9; ++i) {
      if (!board.containsKey(i)) {
        board[i] = isMaximizing ? AI : HUMAN;

        bestScore = isMaximizing
            ? max(bestScore, _miniMax(board, depth + 1, false))
            : min(bestScore, _miniMax(board, depth + 1, true));

        board.remove(i);
      }
    }

    return isMaximizing ? bestScore - depth : bestScore + depth;
  }

  int move(Map<int, Mark> board) {
    int bestScore = -999;
    int bestMove = 0;

    for (int i = 0; i < 9; ++i) {
      if (!board.containsKey(i)) {
        board[i] = AI;
        //false means unbetable AI
        //true means weak AI
        late bool isMaximizing;
        if (gameMode == GameMode.easy) {
          isMaximizing = true;
        } else if (gameMode == GameMode.hard) {
          isMaximizing = false;
        } else {
          isMaximizing = Random().nextBool();
        }
        int score = _miniMax(board, 0, isMaximizing);

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
        board.remove(i);
      }
    }
    return bestMove;
  }
}
