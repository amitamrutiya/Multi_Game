import 'package:flutter/material.dart';
import 'package:multi_game/dimention.dart';

class ModeTile extends StatelessWidget {
  String modeText;
  String imagePath;
  String subTitle;
  VoidCallback onPressed;
  ModeTile(
      {Key? key,
      required this.onPressed,
      required this.modeText,
      required this.subTitle,
      required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: Dimensions.height30 * 3,
            width: Dimensions.width30 * 6,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              color: Dimensions.accentColor,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            modeText,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: Dimensions.font26),
          ),
          Text(subTitle)
        ],
      ),
    );
  }
}
