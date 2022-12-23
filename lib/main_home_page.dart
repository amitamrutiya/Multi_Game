import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_game/2048_game/home_screen.dart';
import 'package:multi_game/ai_tic_tac_toe/home_screen.dart';
import 'package:multi_game/data.dart';
import 'package:multi_game/dianosaur_game/main.dart';
import 'package:multi_game/dimention.dart';
import 'package:multi_game/grid_tile.dart';

import 'package:multi_game/mini_sweeper/widget/game.dart';
import 'package:multi_game/pacman_game/HomePage.dart';
import 'package:multi_game/piano_tile_game/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Dimensions.mainColor,
      body: Container(
        margin: EdgeInsets.all(Dimensions.width30),
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height10),
              decoration: BoxDecoration(
                  color: Dimensions.secondryColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius20)),
              child: Text(
                "Choose Your Game",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Stack(
              children: [
                Container(
                  height: Dimensions.screenHeight / 1.3,
                  decoration: BoxDecoration(
                      color: Dimensions.secondryColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius20)),
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                      vertical: Dimensions.width45),
                  child: Container(
                      padding: EdgeInsets.all(Dimensions.width10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Colors.red,
                          ),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20)),
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: 6,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: Dimensions.width15,
                                  mainAxisSpacing: Dimensions.width15),
                          itemBuilder: (contex, index) {
                            return CustomGridTile(
                              imageName: imageList[index],
                              onPressed: () {
                                if (index == 1) {
                                  Get.to(() => const AITicTacToeHomePage());
                                } else if (index == 0) {
                                  Get.to(() => const HomeScreen2048());
                                } else if (index == 2) {
                                  Get.to(() => Piano());
                                } else if (index == 3) {
                                  Get.to(() => const PacManHomePage());
                                } else if (index == 4) {
                                  Get.to(() => const DianoserGame());
                                } else {
                                  Get.to(() => MiniSweeperGame());
                                }
                              },
                            );
                          })),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: Dimensions.height30 * 2,
                      width: Dimensions.screenWidth / 1.4,
                      child: const Image(
                        image: AssetImage("assets/images/multi_game.png"),
                        fit: BoxFit.fill,
                      ),
                    )),
                Positioned(
                  bottom: 0,
                  left: Dimensions.screenWidth / 3.1,
                  child: Container(
                    height: Dimensions.height10 * 9,
                    width: Dimensions.width10 * 9,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20 / 2),
                        color: Colors.red),
                    child: Icon(
                      Icons.play_arrow,
                      color: Dimensions.mainColor,
                      size: Dimensions.iconSize24 * 3,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
