class Launcher {
  static final Map<Object, Function()> _bullets = {};

  static load(Object key, Function() callback) {
    _bullets[key] = callback;
  }

  static launch(Object key) {
    _bullets[key]?.call();
  }

  static unload(Object key) {
    _bullets.remove(key);
  }
}
