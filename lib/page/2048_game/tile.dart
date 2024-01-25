import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  String number;
  double width, height;
  int color;
  double fontSize;
  int fontcolor;
  Tile(
    this.number,
    this.width,
    this.height,
    this.color,
    this.fontSize,
    this.fontcolor,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Color(color),
          borderRadius: BorderRadius.all(Radius.circular(width / 10))),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(fontcolor)),
        ),
      ),
    );
  }
}
