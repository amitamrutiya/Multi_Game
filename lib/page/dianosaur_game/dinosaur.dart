import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import 'game_object.dart';
import 'ImageModel.dart';

List<ImageModel> dinosaur = [
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/dinosaur/dinosaur_1.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/dinosaur/dinosaur_2.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/dinosaur/dinosaur_3.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/dinosaur/dinosaur_4.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/dinosaur/dinosaur_5.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  ImageModel()
    ..imagePath = "assets/images/dianoser_game/dinosaur/dinosaur_6.png"
    ..imageWidth = 88
    ..imageHeight = 94,
];

enum dinosaurState {
  jumping,
  running,
  dead,
}

class Dinosaur extends GameObject {
  ImageModel currentImageModel = dinosaur[0];
  double dispY = 0;
  double velY = 0;
  dinosaurState state = dinosaurState.running;

  @override
  Widget render() {
    return Image.asset(currentImageModel.imagePath);
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 1.75 - currentImageModel.imageHeight - dispY,
      currentImageModel.imageWidth.toDouble(),
      currentImageModel.imageHeight.toDouble(),
    );
  }

  @override
  void update(Duration lastUpdate, Duration? elapsedTime) {
    // print("Last Update : " + lastUpdate.toString());
    double elapsedTimeSeconds;
    //image of an dinosaur
    try {
      currentImageModel =
          dinosaur[(elapsedTime!.inMilliseconds / 100).floor() % 2 + 2];
    } catch (_) {
      currentImageModel = dinosaur[0];
    }
    // print("currntImageModel : " + currentImageModel.imagePath.toString());

    try {
      elapsedTimeSeconds = (elapsedTime! - lastUpdate).inMilliseconds / 1000;
      // print("elapsedTimeSeconds : " + elapsedTimeSeconds.toString());
    } catch (_) {
      elapsedTimeSeconds = 0;
    }

    dispY = dispY + velY * elapsedTimeSeconds;
    if (dispY <= 0) {
      dispY = 0;
      velY = 0;
      state = dinosaurState.running;
    } else {
      velY = velY - gravity * elapsedTimeSeconds;
    }
  }

  void jump() {
    if (state != dinosaurState.jumping) {
      state = dinosaurState.jumping;
      velY = jumpVelocity;
    }
  }

  void die() {
    currentImageModel = dinosaur[5];
    state = dinosaurState.dead;
  }
}
