import 'package:flutter/widgets.dart';

import 'constants.dart';
import 'game_object.dart';
import 'ImageModel.dart';

ImageModel cloudImageModel = ImageModel()
  ..imagePath = "assets/images/dianoser_game/cloud.png"
  ..imageWidth = 92
  ..imageHeight = 27;

class Cloud extends GameObject {
  final Offset worldLocation;

  Cloud({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worlToPixelRatio / 5,
      screenSize.height / 3 - cloudImageModel.imageHeight - worldLocation.dy,
      cloudImageModel.imageWidth.toDouble(),
      cloudImageModel.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(cloudImageModel.imagePath);
  }
}
