import 'package:flutter/widgets.dart';

import 'constants.dart';
import 'game_object.dart';
import 'ImageModel.dart';

ImageModel groundImageModel = ImageModel()
  ..imagePath = "assets/images/dianoser_game/land.png"
  ..imageWidth = 2399
  ..imageHeight = 24;

class Ground extends GameObject {
  final Offset worldLocation;

  Ground({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worlToPixelRatio,
      screenSize.height / 1.75 - groundImageModel.imageHeight,
      groundImageModel.imageWidth.toDouble(),
      groundImageModel.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(groundImageModel.imagePath);
  }
}
