import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:multi_game/ai_tic_tac_toe/get_winner_func.dart';

import 'package:multi_game/ai_tic_tac_toe/minimax_ai.dart';
import 'package:multi_game/ai_tic_tac_toe/home_screen.dart';
import 'package:multi_game/ai_tic_tac_toe/widgets/game_painter.dart';
import 'package:multi_game/dimention.dart';

class TicTacToe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TicTacToeState();
}

class _TicTacToeState extends State {
  GameMode? gameMode;
  Map<int, Mark> _gameMarks = {};
  Mark _currentMark = Mark.o;
  List<int> _winningLine = [];
  late MiniMaxAI ai;
  @override
  void initState() {
    gameMode = Get.arguments[0];

    if (gameMode != null) {
      ai = MiniMaxAI(gameMode: gameMode!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 246, 217),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Dimensions.accentColortictactoe,
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            gameMode.toString().replaceAll("GameMode.", "").toUpperCase(),
            style: TextStyle(
                fontSize: Dimensions.font26, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width15 / 2),
            child: Divider(
              thickness: 3,
              height: Dimensions.height30,
            ),
          ),
          SizedBox(
            height: Dimensions.height45,
          ),
          GestureDetector(
            onTapUp: (TapUpDetails details) {
              setState(() {
                if (_addMark(
                    x: details.localPosition.dx, y: details.localPosition.dy)) {
                  Winner winner = getWinner(_gameMarks)['winner'];
                  if (winner == Winner.none || winner == Winner.tie) {
                    _addMark(index: ai.move(_gameMarks));
                  }
                }
              });
            },
            child: AspectRatio(
              aspectRatio: 1.0,
              child: CustomPaint(
                painter: GamePainter(_gameMarks, _winningLine),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height45),
          GestureDetector(
            onTap: () {
              setState(() {
                _gameMarks = <int, Mark>{};
                _currentMark = Mark.o;
                _winningLine = [];
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width10 / 2),
              decoration: BoxDecoration(
                  color: Dimensions.accentColor,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(Dimensions.radius20)),
              width: double.infinity,
              height: Dimensions.height45,
              child: Center(
                child: Text(
                  "RESET",
                  style: TextStyle(
                      letterSpacing: 4,
                      color: Colors.black,
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _addMark({int index = -1, double x = -1.0, double y = -1.0}) {
    bool isAbsent = false;

    if (_gameMarks.length >= 9 || _winningLine.isNotEmpty) {
      if (index == -1) {
        _gameMarks = <int, Mark>{};
        _currentMark = Mark.o;
        _winningLine = [];
      }
    } else {
      double dividedSize = GamePainter.getDividedSize();

      if (index == -1) {
        index = (x ~/ dividedSize + (y ~/ dividedSize) * 3).toInt();
      }

      _gameMarks.putIfAbsent(index, () {
        isAbsent = true;
        return _currentMark;
      });

      _winningLine = getWinner(_gameMarks)['winningLine'];

      if (isAbsent) _currentMark = _currentMark == Mark.o ? Mark.x : Mark.o;
    }

    return isAbsent;
  }
}
