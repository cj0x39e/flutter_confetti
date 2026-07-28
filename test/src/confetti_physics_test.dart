import 'package:flutter/material.dart';
import 'package:flutter_confetti/src/confetti_options.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ConfettiPhysics createPhysics(ConfettiOptions options) {
    return ConfettiPhysics.fromOptions(
      options: options,
      color: Colors.red,
    );
  }

  test('particle duration takes precedence over ticks', () {
    final physics = createPhysics(
      const ConfettiOptions(
        ticks: 1,
        particleDuration: Duration(seconds: 1),
      ),
    );

    expect(physics.totalTicks, 60);
  });

  test('particle duration must be greater than zero', () {
    expect(
      () => createPhysics(
        const ConfettiOptions(particleDuration: Duration.zero),
      ),
      throwsArgumentError,
    );
  });

  test('fade-out controls particle opacity', () {
    final fading = createPhysics(const ConfettiOptions());
    final opaque = createPhysics(const ConfettiOptions(fadeOut: false));

    fading.progress = 0.4;
    opaque.progress = 0.4;

    expect(fading.opacity, closeTo(0.6, 0.0001));
    expect(opaque.opacity, 1);
  });

  test('copyWith preserves particle duration unless ticks are selected', () {
    const options = ConfettiOptions(
      particleDuration: Duration(seconds: 2),
      fadeOut: false,
    );

    final copied = options.copyWith(particleCount: 10);
    final usingTicks = options.copyWith(ticks: 30);

    expect(copied.particleDuration, const Duration(seconds: 2));
    expect(copied.fadeOut, isFalse);
    expect(usingTicks.particleDuration, isNull);
    expect(usingTicks.ticks, 30);
  });
}
