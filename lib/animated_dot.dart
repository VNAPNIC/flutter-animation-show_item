import 'package:flutter/material.dart';

class AnimatedDot extends AnimatedWidget {
  final Color color;

  AnimatedDot({
    Key key,
    Animation<double> animation,
    @required this.color,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable;
    return Positioned(
      top: animation.value,
      child: Container(
          margin: EdgeInsets.all(20),
          height: 100.0,
          width: 100.0,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          )),
    );
  }
}
