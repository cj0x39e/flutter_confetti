import 'package:flutter_confetti/src/utils/launcher.dart';

class ConfettiController {
  /// launch the confetti
  launch() {
    Launcher.launch(this);
  }

  /// kill the confetti
  kill() {
    Launcher.kill(this);
  }
}
