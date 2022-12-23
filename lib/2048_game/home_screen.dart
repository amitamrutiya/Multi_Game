import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:multi_game/2048_game/game_screen.dart';
import 'package:multi_game/2048_game/mycolor.dart';

class HomeScreen2048 extends StatefulWidget {
  const HomeScreen2048({Key? key}) : super(key: key);

  @override
  State<HomeScreen2048> createState() => _HomeScreen2048State();
}

class _HomeScreen2048State extends State<HomeScreen2048>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late AnimationController bouncingController;
  double? _scale1;
  final player = AudioPlayer();
  bool music = false;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);

    bouncingController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    bouncingController.dispose();
    player.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    bouncingController.forward();
  }

  void _tapUp(TapUpDetails details) {
    bouncingController.reverse();
  }

  bool ontap3x3 = false;
  bool ontap4x4 = true;
  bool ontap5x5 = false;
  bool ontap6x6 = false;
  @override
  Widget build(BuildContext context) {
    _scale1 = 1 - bouncingController.value;

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '2048',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(MyColor.gridBackground),
      ),
      backgroundColor: Color(MyColor.pageColor),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth / 9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ScaleTransition(
                  scale: animation,
                  child: GestureDetector(
                    onTapUp: _tapUp,
                    onTapDown: _tapDown,
                    child: Transform.scale(
                        scale: _scale1,
                        child: GridTile('3x3.png', '3X3', ontap3x3)),
                    onTap: () {
                      setState(() {
                        ontap3x3 = true;
                        ontap4x4 = false;
                        ontap5x5 = false;
                        ontap6x6 = false;
                      });
                    },
                  ),
                ),
                SizedBox(width: screenWidth / 9),
                ScaleTransition(
                  scale: animation,
                  child: GestureDetector(
                    onTapDown: _tapDown,
                    onTapUp: _tapUp,
                    child: Transform.scale(
                        scale: _scale1,
                        child: GridTile('4x4.png', '4X4', ontap4x4)),
                    onTap: () {
                      setState(() {
                        ontap3x3 = false;
                        ontap4x4 = true;
                        ontap5x5 = false;
                        ontap6x6 = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ScaleTransition(
                  scale: animation,
                  child: GestureDetector(
                    onTapUp: _tapUp,
                    onTapDown: _tapDown,
                    child: Transform.scale(
                        scale: _scale1,
                        child: GridTile('5x5.png', '5X5', ontap5x5)),
                    onTap: () {
                      setState(() {
                        ontap3x3 = false;
                        ontap4x4 = false;
                        ontap5x5 = true;
                        ontap6x6 = false;
                      });
                    },
                  ),
                ),
                SizedBox(width: screenWidth / 9),
                ScaleTransition(
                  scale: animation,
                  child: GestureDetector(
                    onTapDown: _tapDown,
                    onTapUp: _tapUp,
                    child: Transform.scale(
                        scale: _scale1,
                        child: GridTile('6x6.png', '6X6', ontap6x6)),
                    onTap: () {
                      setState(() {
                        ontap3x3 = false;
                        ontap4x4 = false;
                        ontap5x5 = false;
                        ontap6x6 = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 90,
                ),
                InkWell(
                  onTap: () async {
                    if (music) {
                      await player.play(
                          AssetSource('music/2048/menu_button_click.mp3'));
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute<bool>(
                          builder: (context) => GamePage(
                              [ontap3x3, ontap4x4, ontap5x5, ontap6x6], music)),
                    ).then((value) => setState(() {
                          music = value as bool;
                        }));
                  },
                  child: ScaleTransition(
                    scale: animation,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  child: Icon(
                    music ? Icons.music_note_rounded : Icons.music_off_rounded,
                    size: 45,
                    color: Color(MyColor.gridBackground),
                  ),
                  onTap: () async {
                    await player
                        .play(AssetSource('music/2048/menu_button_click.mp3'));
                    setState(() {
                      music = !music;
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GridTile extends StatelessWidget {
  final String imageName;
  final String subtitle;
  final bool onTap;

  const GridTile(this.imageName, this.subtitle, this.onTap);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center  ,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 4,
                color: Color(MyColor.emptyGridBackground),
              ),
              borderRadius: BorderRadius.circular(10)),
          height: screenHeight / 6,
          width: screenWidth / 3,
          child: Image.asset(
            "assets/images/2048/$imageName",
            fit: BoxFit.contain,
            color: onTap == false
                ? const Color.fromRGBO(255, 255, 255, 0.5)
                : null,
            colorBlendMode: onTap == false ? BlendMode.modulate : null,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          subtitle,
          style:
              TextStyle(fontSize: 20, color: Color(MyColor.fontColorfor4and2)),
        ),
      ],
    );
  }
}
