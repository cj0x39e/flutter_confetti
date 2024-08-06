import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_confetti/src/utils/glue.dart';

class Painter extends CustomPainter {
  final List<Glue> glueList;

  const Painter({required this.glueList});

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < glueList.length; i++) {
      final glue = glueList[i];
      if (!glue.physics.finished) {
        glue.particle.paint(physics: glue.physics, canvas: canvas);
      }
    }
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) {
    return true;
  }
}
