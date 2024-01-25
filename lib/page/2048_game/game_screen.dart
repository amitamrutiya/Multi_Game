import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mycolor.dart';
import 'tile.dart';
import 'grid.dart';
import 'game.dart';
import 'package:audioplayers/audioplayers.dart';

class GamePage extends StatefulWidget {
  final List<bool> args;
  final bool music;
  const GamePage(this.args, this.music);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GamePageState();
  }
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late AnimationController bouncingController;
  double? _scale;
  int userInputRow = 0;
  int userInputCol = 0;

  final player = AudioPlayer();
  bool? music;

  @override
  void initState() {
    music = widget.music;
    if (widget.args[0] == true) {
      userInputRow = 3;
      userInputCol = 3;
    } else if (widget.args[1] == true) {
      userInputRow = 4;
      userInputCol = 4;
    } else if (widget.args[2] == true) {
      userInputRow = 5;
      userInputCol = 5;
    } else if (widget.args[3] == true) {
      userInputRow = 6;
      userInputCol = 6;
    }

    grid = blankGrid(userInputRow, userInputCol);
    addNumber(grid, userInputRow, userInputCol);
    addNumber(grid, userInputRow, userInputCol);
    bouncingController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  List<List<int>> grid = [];
  late SharedPreferences sharedPreferences;
  int score = 0;
  bool isgameOver = false;
  bool isgameWon = false;

  List<Widget> getGrid(double width, double height) {
    List<Widget> grids = [];
    for (int i = 0; i < userInputRow; i++) {
      for (int j = 0; j < userInputCol; j++) {
        int num = grid[i][j];
        String number;
        int color;
        int fontColor = 0xffffffff;
        if (num == 0) {
          color = MyColor.emptyGridBackground;
          number = "";
        } else if (num == 2) {
          color = MyColor.gridColor2;
          number = "$num";
          fontColor = MyColor.fontColorfor4and2;
        } else if (num == 4) {
          color = MyColor.gridColor4;
          number = "$num";
          fontColor = MyColor.fontColorfor4and2;
        } else if (num == 8) {
          color = MyColor.gridColor8;
          number = "$num";
        } else if (num == 16) {
          color = MyColor.gridColor16;
          number = "$num";
        } else if (num == 32) {
          color = MyColor.gridColor32;
          number = "$num";
        } else if (num == 64) {
          color = MyColor.gridColor64;
          number = "$num";
        } else if (num == 128) {
          color = MyColor.gridColor128;
          number = "$num";
        } else if (num == 256) {
          color = MyColor.gridColor256;
          number = "$num";
        } else if (num == 512) {
          color = MyColor.gridColor512;
          number = "$num";
        } else if (num == 1028) {
          color = MyColor.gridColor1028;
          number = "$num";
        } else {
          color = MyColor.gridColorWin;
          number = "$num";
        }
        double size = 0;
        String n = number;
        switch (n.length) {
          case 1:
            size = width / 2;
            break;
          case 2:
            size = width / 2.5;
            break;
          case 3:
            size = width / 3;
            break;
          case 4:
            size = width / 4;
            break;
        }
        grids.add(Tile(
          number,
          width,
          height,
          color,
          size,
          fontColor,
        ));
      }
    }
    return grids;
  }

  Future<void> handleGesture(int direction) async {
    /*
      0 = up
      1 = down
      2 = right
      3 = right
    */
    bool flipped = false;
    bool played = true;
    bool rotated = false;
    if (direction == 0) {
      print("$direction up");
      setState(() {
        grid = transposeGrid(grid, userInputRow, userInputCol);
        grid = flipGrid(grid, userInputRow);
        rotated = true;
        flipped = true;
      });
    } else if (direction == 1) {
      print("$direction down");
      setState(() {
        grid = transposeGrid(grid, userInputRow, userInputCol);
        rotated = true;
      });
    } else if (direction == 2) {
      print("$direction right");
    } else if (direction == 3) {
      print("$direction left");
      setState(() {
        grid = flipGrid(grid, userInputRow);
        flipped = true;
      });
    } else {
      played = false;
    }

    if (played) {
      List<List<int>> past = copyGrid(grid, userInputRow, userInputCol);
      for (int i = 0; i < userInputRow; i++) {
        List result = await operate(grid[i], score, sharedPreferences,
            userInputRow, userInputCol, music!);
        setState(() {
          score = result[0];
          grid[i] = result[1];
        });
      }
      setState(() {
        grid = addNumber(grid, userInputRow, userInputCol);

        print(flipped);
      });
      bool changed = compare(past, grid, userInputRow, userInputCol);
      print('changed $changed');
      if (flipped) {
        setState(() {
          grid = flipGrid(grid, userInputRow);
        });
      }

      if (rotated) {
        setState(() {
          grid = transposeGrid(grid, userInputRow, userInputCol);
        });
      }

      if (changed) {
        setState(() {
          grid = addNumber(grid, userInputRow, userInputCol);
          print('is changed');
        });
      } else {
        print('not changed');
      }

      bool gameover = isGameOver(grid, userInputRow, userInputCol);
      if (gameover) {
        print('game over');
        setState(() {
          isgameOver = true;
        });
      }

      bool gamewon = isGameWon(grid, userInputRow, userInputCol);
      if (gamewon) {
        print("GAME WON");
        setState(() {
          isgameWon = true;
        });
      }
      print(grid);
      print(score);
    }
  }

  Future<String> getHighScore() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int? score =
        sharedPreferences.getInt('high_score$userInputRow$userInputCol');
    score ??= 0;
    return score.toString();
  }

  void _tapDown(TapDownDetails details) {
    bouncingController.forward();
  }

  void _tapUp(TapUpDetails details) {
    bouncingController.reverse();
  }

  @override
  void dispose() {
    bouncingController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - bouncingController.value;
    double width = MediaQuery.of(context).size.width;
    double gridWidth = (width - 80) / userInputCol;
    double gridHeight = gridWidth;
    double height = 30 + (gridHeight * userInputRow) + 15;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            if (music == true) {
              await player
                  .play(AssetSource('music/2048/menu_button_click.mp3'));
            }
            Navigator.pop(context, music);
          },
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          '2048 $userInputRow X $userInputCol',
          style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(MyColor.gridBackground),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(MyColor.gridBackground),
                  ),
                  height: 82.0,
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                        child: Text(
                          'Score',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          '$score',
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: height,
                color: Color(MyColor.gridBackground),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        child: GridView.count(
                          primary: false,
                          crossAxisSpacing: height / 35,
                          mainAxisSpacing: width / 35,
                          crossAxisCount: userInputCol,
                          children: getGrid(gridWidth, gridHeight),
                        ),
                        onVerticalDragEnd: (DragEndDetails details) {
                          //primaryVelocity -ve up +ve down
                          if (details.primaryVelocity! < 0) {
                            handleGesture(0);
                          } else if (details.primaryVelocity! > 0) {
                            handleGesture(1);
                          }
                        },
                        onHorizontalDragEnd: (details) {
                          //-ve right, +ve left
                          if (details.primaryVelocity! > 0) {
                            handleGesture(2);
                          } else if (details.primaryVelocity! < 0) {
                            handleGesture(3);
                          }
                        },
                      ),
                    ),
                    isgameOver
                        ? Container(
                            height: height,
                            color: Color(MyColor.transparentWhite),
                            child: Center(
                              child: Text(
                                'Game over!',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(MyColor.gridBackground)),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    isgameWon
                        ? Container(
                            height: height,
                            color: Color(MyColor.transparentWhite),
                            child: Center(
                              child: Text(
                                'You Won!',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(MyColor.gridBackground)),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTapDown: _tapDown,
                      onTapUp: _tapUp,
                      child: Transform.scale(
                        scale: _scale,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color(MyColor.gridBackground),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white70,
                              size: 45,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (music!) {
                          await player.play(
                              AssetSource('music/2048/menu_button_click.mp3'));
                        }
                        setState(() {
                          grid = blankGrid(userInputRow, userInputCol);

                          grid = addNumber(grid, userInputRow, userInputCol);
                          grid = addNumber(grid, userInputRow, userInputCol);
                          score = 0;
                          isgameOver = false;
                          isgameWon = false;
                        });
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(MyColor.gridBackground),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            const Text(
                              'High Score',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            ),
                            FutureBuilder<String>(
                              future: getHighScore(),
                              builder: (ctx, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return const Text(
                                    '0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                child: Icon(
                  music! ? Icons.music_note_rounded : Icons.music_off_rounded,
                  size: 45,
                  color: Color(MyColor.gridBackground),
                ),
                onTap: () async {
                  await player
                      .play(AssetSource('music/2048/menu_button_click.mp3'));
                  setState(() {
                    music = !music!;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
