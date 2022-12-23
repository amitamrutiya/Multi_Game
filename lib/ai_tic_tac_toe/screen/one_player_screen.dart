import 'package:multi_game/ai_tic_tac_toe/home_screen.dart';
import 'package:multi_game/ai_tic_tac_toe/screen/tic_tac_toe_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:multi_game/ai_tic_tac_toe/widgets/game_mode_tile.dart';
import 'package:multi_game/dimention.dart';

class OnePlayerScreen extends StatelessWidget {
  const OnePlayerScreen({Key? key}) : super(key: key);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ModeTile(
                  subTitle: "You Never Loose",
                  onPressed: (() {
                    GameMode gameMode = GameMode.easy;
                    Get.to(() => TicTacToe(),
                        arguments: [gameMode], transition: Transition.fadeIn);
                  }),
                  modeText: "Easy",
                  imagePath: "assets/images/tic_tac_toe/1star.png",
                ),
                const SizedBox(
                  width: 20,
                ),
                ModeTile(
                  onPressed: (() {
                    GameMode gameMode = GameMode.medium;
                    Get.to(() => TicTacToe(),
                        arguments: [gameMode], transition: Transition.fadeIn);
                  }),
                  subTitle: "50% Chance",
                  modeText: "Medium",
                  imagePath: "assets/images/tic_tac_toe/2star.png",
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.height45,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ModeTile(
                  subTitle: "You Never Win",
                  onPressed: () {
                    GameMode gameMode = GameMode.hard;
                    Get.to(() => TicTacToe(),
                        arguments: [gameMode], transition: Transition.fadeIn);
                  },
                  modeText: "Hard",
                  imagePath: "assets/images/tic_tac_toe/3star.png",
                ),
              ],
            )
          ],
        ));
  }
}
