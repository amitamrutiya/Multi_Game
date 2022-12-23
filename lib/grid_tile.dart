import 'package:flutter/material.dart';
import 'package:multi_game/dimention.dart';

class CustomGridTile extends StatefulWidget {
  final String imageName;
  final VoidCallback onPressed;
  const CustomGridTile(
      {Key? key, required this.imageName, required this.onPressed})
      : super(key: key);

  @override
  State<CustomGridTile> createState() => _CustomGridTileState();
}

class _CustomGridTileState extends State<CustomGridTile>
    with TickerProviderStateMixin {
  late AnimationController bouncingController;
  late Animation<double> animation;
  late AnimationController controller;
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

  double? _scale;

  @override
  Widget build(BuildContext context) {
    _scale = 1 - bouncingController.value;
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTap: widget.onPressed,
      child: Transform.scale(
        scale: _scale,
        child: ScaleTransition(
          scale: animation,
          child: Container(
            height: Dimensions.height10 * 30,
            width: Dimensions.height10 * 30,
            decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(color: Dimensions.mainColor, width: 7),
                borderRadius: BorderRadius.circular(Dimensions.radius20)),
            child: Image.asset(
              "assets/images/${widget.imageName}",
              height: Dimensions.height10 * 30,
              width: Dimensions.height10 * 30,
              fit: BoxFit.fill,
            ),

            // height: D,
          ),
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    bouncingController.forward();
  }

  void _tapUp(TapUpDetails details) {
    bouncingController.reverse();
  }
}
