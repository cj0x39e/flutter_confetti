import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_confetti/src/utils/glue.dart';

class Painter extends CustomPainter {
  List<Glue> glueList = [];

  Painter({required this.glueList});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) {
      return;
    }

    final width = size.width;
    final height = size.height;

    for (var i = 0; i < glueList.length; i++) {
      final glue = glueList[i];

      if (!glue.physics.finished) {
        glue.physics.initOrigin(width, height);
        glue.physics.update();
        glue.particle.paint(
          physics: glue.physics,
          canvas: canvas,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
