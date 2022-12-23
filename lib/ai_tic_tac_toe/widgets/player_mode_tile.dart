import 'package:flutter/material.dart';
import 'package:multi_game/dimention.dart';

class PlayerModeTile extends StatelessWidget {
  String mainText;
  IconData icon1;
  IconData icon2;
  VoidCallback onButtonPressed;
  PlayerModeTile({
    required this.mainText,
    required this.icon1,
    required this.icon2,
    required this.onButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonPressed,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        height: Dimensions.height45 * 2,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 243, 159, 153),
            border: Border.all(width: 3),
            borderRadius: BorderRadius.circular(Dimensions.radius15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mainText,
              style: TextStyle(
                  fontSize: Dimensions.font20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: Dimensions.width20),
            Icon(
              icon1,
              size: Dimensions.iconSize16 * 2,
            ),
            Text(
              mainText.contains("Single") ? "vs " : "vs",
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              icon2,
              size: Dimensions.iconSize16 * 2,
            )
          ],
        ),
      ),
    );
  }
}
