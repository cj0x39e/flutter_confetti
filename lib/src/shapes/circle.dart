import 'dart:math';
import 'dart:ui';

import 'package:flutter_confetti/src/confetti_particle.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';

class Circle extends ConfettiParticle {
  @override
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    canvas.save();

    canvas.translate(physics.x, physics.y);
    canvas.rotate(pi / 10 * physics.wobble);
    canvas.scale(
      (physics.x2 - physics.x1).abs() * physics.ovalScalar,
      (physics.y2 - physics.y1).abs() * physics.ovalScalar,
    );

    final paint = Paint()
      ..color = physics.color.withOpacity(1 - physics.progress);

    canvas.drawArc(Rect.fromCircle(center: const Offset(0, 0), radius: 1), 0,
        2 * pi, true, paint);

    canvas.restore();
  }
}
