import 'package:flutter/material.dart';

import 'package:multi_game/ai_tic_tac_toe/get_winner_func.dart';

import 'package:multi_game/ai_tic_tac_toe/home_screen.dart';
import 'package:multi_game/ai_tic_tac_toe/widgets/game_painter.dart';
import 'package:multi_game/dimention.dart';

class TwoPlayerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TwoPlayerScreenState();
}

class _TwoPlayerScreenState extends State {
  Map<int, Mark> _gameMarks = {};
  Mark _currentMark = Mark.o;
  List<int> _winningLine = [];
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
          GestureDetector(
            onTapUp: (TapUpDetails details) {
              setState(() {
                if (_gameMarks.length >= 9 || _winningLine.isNotEmpty) {
                  _gameMarks = <int, Mark>{};
                  _currentMark = Mark.o;
                  _winningLine = [];
                } else {
                  _addMark(details.localPosition.dx, details.localPosition.dy);
                  _winningLine = getWinner(_gameMarks)['winningLine'];
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

  void _addMark(double x, double y) {
    bool isAbsent = false;
    double dividedSize = GamePainter.getDividedSize();
    _gameMarks.putIfAbsent((x ~/ dividedSize + (y ~/ dividedSize) * 3).toInt(),
        () {
      isAbsent = true;
      return _currentMark;
    });
    if (isAbsent) _currentMark = _currentMark == Mark.o ? Mark.x : Mark.o;
  }
}
