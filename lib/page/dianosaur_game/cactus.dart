import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:multi_combo_game/page/dianosaur_game/ImageModel.dart';

import 'constants.dart';
import 'game_object.dart';

List<ImageModel> cactus = [
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/cactus/cactus_group.png"
    ..imageWidth = 80
    ..imageHeight = 83,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/cactus/cactus_large_1.png"
    ..imageWidth = 50
    ..imageHeight = 100,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/cactus/cactus_large_2.png"
    ..imageWidth = 84
    ..imageHeight = 85,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/cactus/cactus_small_1.png"
    ..imageWidth = 34
    ..imageHeight = 70,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/cactus/cactus_small_2.png"
    ..imageWidth = 68
    ..imageHeight = 70,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/cactus/cactus_small_3.png"
    ..imageWidth = 90
    ..imageHeight = 60,
];

class Cactus extends GameObject {
  final ImageModel imageModel;
  final Offset worldLocation;

  Cactus({required this.worldLocation})
      : imageModel = cactus[Random().nextInt(cactus.length)];

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worlToPixelRatio,
      screenSize.height / 1.75 - imageModel.imageHeight,
      imageModel.imageWidth.toDouble(),
      imageModel.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(imageModel.imagePath);
  }
}
