import 'package:flutter_confetti/src/utils/launcher_config.dart';

class Launcher {
  static final Map<Object, LauncherConfig> _bullets = {};

  static load(Object key, LauncherConfig launcherConfig) {
    _bullets[key] = launcherConfig;
  }

  static launch(Object key) {
    _bullets[key]?.onLaunch();
  }

  static kill(Object key) {
    _bullets[key]?.onKill();
  }

  static unload(Object key) {
    _bullets.remove(key);
  }
}
