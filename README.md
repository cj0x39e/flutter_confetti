<p align="center">
  <a href="https://tao-zhi-1992.github.io/flutter_confetti/">
    <img src="doc/header.png" alt="Flutter Confetti" width="720" />
  </a>
</p>

<p align="center">
  <a href="https://pub.dev/packages/flutter_confetti"><img src="https://img.shields.io/pub/v/flutter_confetti.svg" alt="pub package"></a>
  <a href="https://pub.dev/packages/flutter_confetti"><img src="https://img.shields.io/pub/likes/flutter_confetti" alt="likes"></a>
  <a href="https://pub.dev/packages/flutter_confetti/score"><img src="https://img.shields.io/pub/points/flutter_confetti" alt="pub points"></a>
  <a href="https://github.com/tao-zhi-1992/flutter_confetti/stargazers"><img src="https://img.shields.io/github/stars/tao-zhi-1992/flutter_confetti?style=flat" alt="GitHub stars"></a>
  <a href="https://github.com/tao-zhi-1992/flutter_confetti/blob/main/LICENSE"><img src="https://img.shields.io/github/license/tao-zhi-1992/flutter_confetti" alt="license"></a>
</p>

<p align="center">
  Easily create confetti animations in Flutter.
</p>

<p align="center">
  <a href="https://tao-zhi-1992.github.io/flutter_confetti/">Live demo</a>
  ·
  <a href="https://github.com/tao-zhi-1992/flutter_confetti/blob/main/doc/guide.md">Guide</a>
</p>

## Install

```bash
flutter pub add flutter_confetti
```

Or add it to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_confetti: ^0.9.0
```

## Quick start

```dart
import 'package:flutter_confetti/flutter_confetti.dart';

Confetti.launch(
  context,
  options: const ConfettiOptions(
    particleCount: 100,
    spread: 70,
    y: 0.6,
  ),
);
```

## Thanks

This package was totally inspired by [canvas-confetti](https://github.com/catdad/canvas-confetti), a wonderful confetti animation library for the browser.
I just did a little work to bring it to Flutter.
