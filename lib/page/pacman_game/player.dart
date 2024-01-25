import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  const MyPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(
        'assets/images/pac_man/pacman.png',
      ),
    );
  }
}
