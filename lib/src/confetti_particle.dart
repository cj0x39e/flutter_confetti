import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';

abstract class ConfettiParticle {
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  });
}
