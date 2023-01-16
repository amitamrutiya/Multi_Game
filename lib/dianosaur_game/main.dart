import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_game/dianosaur_game/dinosaur.dart';
import 'cactus.dart';
import 'cloud.dart';

import 'game_object.dart';
import 'ground.dart';
import 'constants.dart';

class DianoserGame extends StatelessWidget {
  const DianoserGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return const MaterialApp(
      title: 'Dinosuar',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Dinosaur dinosaur = Dinosaur();
  double runVelocity = initialVelocity;
  double runDistance = 0;
  bool hackMode = false;
  int highScore = 0;
  TextEditingController gravityController =
      TextEditingController(text: gravity.toString());
  TextEditingController accelerationController =
      TextEditingController(text: acceleration.toString());
  TextEditingController jumpVelocityController =
      TextEditingController(text: jumpVelocity.toString());
  TextEditingController runVelocityController =
      TextEditingController(text: initialVelocity.toString());
  TextEditingController dayNightOffestController =
      TextEditingController(text: dayNightOffest.toString());

  late AnimationController worldController;
  Duration lastUpdateCall = const Duration();

  List<Cactus> cacti = [Cactus(worldLocation: const Offset(200, 0))];

  List<Ground> ground = [
    Ground(worldLocation: const Offset(0, 0)),
    Ground(worldLocation: Offset(groundImageModel.imageWidth / 10, 0))
  ];

  List<Cloud> clouds = [
    Cloud(worldLocation: const Offset(100, 20)),
    Cloud(worldLocation: const Offset(200, 10)),
    Cloud(worldLocation: const Offset(350, -10)),
  ];

  @override
  void initState() {
    super.initState();
    worldController =
        AnimationController(vsync: this, duration: const Duration(days: 99));
    worldController.addListener(_update);
    // worldController.forward();
    _die();
  }

  void _die() {
    setState(() {
      worldController.stop();
      dinosaur.die();
    });
  }

  void _newGame() {
    setState(() {
      highScore = max(highScore, runDistance.toInt());
      runDistance = 0;
      runVelocity = initialVelocity;
      dinosaur.state = dinosaurState.running;
      dinosaur.dispY = 0;
      worldController.reset();
      cacti = [
        Cactus(worldLocation: const Offset(200, 0)),
        Cactus(worldLocation: const Offset(300, 0)),
        Cactus(worldLocation: const Offset(450, 0)),
      ];

      ground = [
        Ground(worldLocation: const Offset(0, 0)),
        Ground(worldLocation: Offset(groundImageModel.imageWidth / 10, 0))
      ];

      clouds = [
        Cloud(worldLocation: const Offset(100, 20)),
        Cloud(worldLocation: const Offset(200, 10)),
        Cloud(worldLocation: const Offset(350, -15)),
        Cloud(worldLocation: const Offset(500, 10)),
        Cloud(worldLocation: const Offset(550, -10)),
      ];

      worldController.forward();
    });
  }

  _update() {
    try {
      double elapsedTimeSeconds;
      print(worldController.lastElapsedDuration);
      dinosaur.update(lastUpdateCall, worldController.lastElapsedDuration);
      try {
        elapsedTimeSeconds =
            (worldController.lastElapsedDuration! - lastUpdateCall)
                    .inMilliseconds /
                1000;
      } catch (_) {
        elapsedTimeSeconds = 0;
      }

      runDistance = runDistance + runVelocity * elapsedTimeSeconds;
      if (runDistance < 0) runDistance = 0;
      //increase a speed of dinosaur
      // runVelocity += acceleration * elapsedTimeSeconds;

      Size screenSize = MediaQuery.of(context).size;

      Rect dinosaurRect = dinosaur.getRect(screenSize, runDistance);
      for (Cactus cactus in cacti) {
        Rect obstacleRect = cactus.getRect(screenSize, runDistance);
        if (hackMode == false &&
            dinosaurRect.overlaps(obstacleRect.deflate(30))) {
          _die();
        }

        if (obstacleRect.right < 0) {
          var offsetX = runDistance +
              150 +
              MediaQuery.of(context).size.width / worlToPixelRatio;

          setState(() {
            cacti.remove(cactus);
            cacti.add(Cactus(worldLocation: Offset(offsetX, 0)));
          });
        }
      }

      for (Ground groundlet in ground) {
        if (groundlet.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            ground.remove(groundlet);
            ground.add(
              Ground(
                worldLocation: Offset(
                  ground.last.worldLocation.dx +
                      groundImageModel.imageWidth / 10,
                  0,
                ),
              ),
            );
          });
        }
      }

      for (Cloud cloud in clouds) {
        if (cloud.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            clouds.remove(cloud);
            clouds.add(
              Cloud(
                worldLocation: Offset(
                  clouds.last.worldLocation.dx +
                      Random().nextInt(200) +
                      MediaQuery.of(context).size.width / worlToPixelRatio,
                  Random().nextInt(50) - 25.0,
                ),
              ),
            );
          });
        }
      }

      lastUpdateCall = worldController.lastElapsedDuration!;
    } catch (e) {
      print("Got Error");
    }
  }

  @override
  void dispose() {
    worldController.dispose();
    gravityController.dispose();
    accelerationController.dispose();
    jumpVelocityController.dispose();
    runVelocityController.dispose();
    dayNightOffestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    List<AnimatedBuilder> children = [];

    for (GameObject object in [...clouds, ...ground, ...cacti, dinosaur]) {
      children.add(
        AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            print("$object  $objectRect");
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 5000),
        color: (runDistance ~/ dayNightOffest) % 2 == 0
            ? Colors.white
            : Colors.black,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (dinosaur.state != dinosaurState.dead) {
              dinosaur.jump();
            }
            if (dinosaur.state == dinosaurState.dead) {
              _newGame();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...children,
              AnimatedBuilder(
                animation: worldController,
                builder: (context, _) {
                  return Positioned(
                    left: screenSize.width / 2 - 30,
                    top: 100,
                    child: Text(
                      'Score: ${runDistance.toInt()}',
                      style: TextStyle(
                        color: (runDistance ~/ dayNightOffest) % 2 == 0
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: worldController,
                builder: (context, _) {
                  return Positioned(
                    left: screenSize.width / 2 - 50,
                    top: 120,
                    child: Text(
                      'High Score: $highScore',
                      style: TextStyle(
                        color: (runDistance ~/ dayNightOffest) % 2 == 0
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                right: 20,
                top: 20,
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    _die();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: const Text("Change Physics"),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 25,
                                  width: 280,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Hack Mode:"),
                                      SizedBox(
                                          height: 25,
                                          width: 75,
                                          child: Switch(
                                              value: hackMode,
                                              onChanged: (bool val) {
                                                setState(() {
                                                  hackMode = !hackMode;
                                                  initialVelocity = 70;
                                                });
                                              })),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 25,
                                  width: 280,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Gravity:"),
                                      SizedBox(
                                        height: 25,
                                        width: 75,
                                        child: TextField(
                                          controller: gravityController,
                                          key: UniqueKey(),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 25,
                                  width: 280,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Acceleration:"),
                                      SizedBox(
                                        height: 25,
                                        width: 75,
                                        child: TextField(
                                          controller: accelerationController,
                                          key: UniqueKey(),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 25,
                                  width: 280,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Initial Velocity:"),
                                      SizedBox(
                                        height: 25,
                                        width: 75,
                                        child: TextField(
                                          controller: runVelocityController,
                                          key: UniqueKey(),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 25,
                                  width: 280,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Jump Velocity:"),
                                      SizedBox(
                                        height: 25,
                                        width: 75,
                                        child: TextField(
                                          controller: jumpVelocityController,
                                          key: UniqueKey(),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 25,
                                  width: 280,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Day-Night Offset:"),
                                      SizedBox(
                                        height: 25,
                                        width: 75,
                                        child: TextField(
                                          controller: dayNightOffestController,
                                          key: UniqueKey(),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 240, 240, 240))),
                                onPressed: () {
                                  gravity = int.parse(gravityController.text);
                                  acceleration =
                                      double.parse(accelerationController.text);
                                  initialVelocity =
                                      double.parse(runVelocityController.text);
                                  jumpVelocity =
                                      double.parse(jumpVelocityController.text);
                                  dayNightOffest =
                                      int.parse(dayNightOffestController.text);
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Done",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          );
                        });
                      },
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                child: TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 240, 240, 240))),
                  onPressed: () {
                    _die();
                  },
                  child: const Text(
                    "Force Kill dinosaur",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
