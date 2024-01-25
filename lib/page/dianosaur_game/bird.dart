import './constants.dart';
import 'package:flutter/widgets.dart';

import 'game_object.dart';
import 'ImageModel.dart';

List<ImageModel> birdFrames = [
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/bird/bird_1.png"
    ..imageHeight = 80
    ..imageWidth = 92,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/bird/bird_2.png"
    ..imageHeight = 80
    ..imageWidth = 92,
];

class Bird extends GameObject {
  final Offset worldLocation;
  int frame = 0;

  Bird({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
        (worldLocation.dx - runDistance) * worlToPixelRatio,
        4 / 7 * screenSize.height -
            birdFrames[frame].imageHeight -
            worldLocation.dy,
        birdFrames[frame].imageWidth.toDouble(),
        birdFrames[frame].imageHeight.toDouble());
  }

  @override
  Widget render() {
    return Image.asset(
      birdFrames[frame].imagePath,
      gaplessPlayback: true,
    );
  }

  @override
  void update(Duration lastUpdate, Duration elapsedTime) {
    frame = (elapsedTime.inMilliseconds / 200).floor() % 2;
  }
}
