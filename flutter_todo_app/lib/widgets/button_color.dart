import 'package:flutter/material.dart';

final buttonColor = Container(
  decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [Colors.purple, Colors.purpleAccent])),
);

/*class ButtonColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Colors.purple, Colors.purpleAccent])),
    );
  }
}*/
