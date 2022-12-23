import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_game/ai_tic_tac_toe/screen/one_player_screen.dart';
import 'package:multi_game/ai_tic_tac_toe/widgets/player_mode_tile.dart';
import 'package:multi_game/ai_tic_tac_toe/screen/two_player_screen.dart';
import 'package:multi_game/dimention.dart';

enum Mark { x, o, none }

enum Winner { x, o, tie, none }

enum GameMode { easy, medium, hard }

enum PlayerMode { singleplayer, twoplayer }

const AI = Mark.x;
const HUMAN = Mark.o;

const STROKE_WIDTH = 6.0;
const HALF_STROKE_WIDTH = STROKE_WIDTH / 2.0;
const DOUBLE_STROKE_WIDTH = STROKE_WIDTH * 2.0;

class AITicTacToeHomePage extends StatelessWidget {
  const AITicTacToeHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 246, 217),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Dimensions.accentColortictactoe,
        title: const Text("Tic Tac Toe"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/tic_tac_toe/tic tac toe.png",
            height: Dimensions.height10 * 40,
            width: Dimensions.width10 * 40,
          ),
          PlayerModeTile(
              mainText: "Single Player",
              icon1: Icons.person_outline,
              icon2: Icons.computer_outlined,
              onButtonPressed: (() {
                Get.to(() => const OnePlayerScreen(),
                    transition: Transition.fadeIn);
              })),
          SizedBox(
            height: Dimensions.height30,
          ),
          PlayerModeTile(
              mainText: "Two Player",
              icon1: Icons.person_outline,
              icon2: Icons.person_outline,
              onButtonPressed: (() {
                Get.to(() => TwoPlayerScreen(), transition: Transition.fadeIn);
              })),
        ],
      ),
    );
  }
}
