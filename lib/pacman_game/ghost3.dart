import 'package:flutter/material.dart';

class MyGhost3 extends StatelessWidget {
  const MyGhost3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Image.asset('assets/images/pac_man/ghost3.png'),
    );
  }
}
