import 'package:flutter_confetti/src/confetti_controller.dart';
import 'package:flutter_confetti/src/utils/launcher.dart';
import 'package:flutter_confetti/src/utils/launcher_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ConfettiController controller;
  int counter = 0;

  setUp(() {
    controller = ConfettiController();
    Launcher.load(
        controller,
        LauncherConfig(
            onLaunch: () {
              counter++;
            },
            onKill: () {}));
  });

  tearDown(() {
    counter = 0;
    Launcher.unload(controller);
  });

  test('the counter should be 1', () {
    controller.launch();
    expect(counter, equals(1));
  });

  test('the counter should be 2', () {
    controller.launch();
    controller.launch();
    expect(counter, equals(2));
  });

  test('the counter should be 0', () {
    Launcher.unload(controller);
    controller.launch();
    expect(counter, equals(0));
  });
}
