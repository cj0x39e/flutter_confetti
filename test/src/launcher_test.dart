import 'package:flutter_confetti/src/utils/launcher.dart';
import 'package:flutter_confetti/src/utils/launcher_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('callback should be called', () {
    const key = Object();
    int counter = 0;
    Launcher.load(
        key,
        LauncherConfig(
            onLaunch: () {
              counter++;
            },
            onKill: () {}));
    Launcher.launch(key);
    expect(counter, equals(1));
  });

  test('callback should not be called after unload', () {
    const key = Object();
    int counter = 0;

    Launcher.load(
        key,
        LauncherConfig(
            onLaunch: () {
              counter++;
            },
            onKill: () {}));

    Launcher.unload(key);
    Launcher.launch(key);

    expect(counter, equals(0));
  });
}
