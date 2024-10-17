import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import 'package:flutter_confetti/src/confetti_particle.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';

class Emoji extends ConfettiParticle {
  final String emoji;
  final TextStyle textStyle;

  Emoji({
    required this.emoji,
    required this.textStyle,
  });

  ui.Image? _cachedImage;

  Future<ui.Image> _createTextImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final fontSize = textStyle.fontSize ?? 18;
    final width = fontSize + 2;

    final textPainter = TextPainter(
      text: TextSpan(text: emoji, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: width);
    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    return picture.toImage(width.toInt(), width.toInt());
  }

  @override
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    if (_cachedImage == null) {
      _createTextImage().then((image) {
        _cachedImage = image;
      });
      return;
    }

    canvas.save();

    canvas.translate(physics.x, physics.y);
    canvas.rotate(pi / 10 * physics.wobble);

    final paint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, 1 - physics.progress);

    canvas.drawImage(_cachedImage!, Offset.zero, paint);

    canvas.restore();
  }
}
