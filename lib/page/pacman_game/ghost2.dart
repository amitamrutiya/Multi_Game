import 'package:flutter/material.dart';

class MyGhost2 extends StatelessWidget {
  const MyGhost2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Image.asset('assets/images/pac_man/ghost2.png'),
    );
  }
}
