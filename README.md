# 🎉  Flutter Confetti 🎉 

Easily make confetti animation in Flutter.

## Features

- easy to use.
- various out-of-the-box shapes, like the circle, the star, the square, and more.
- many examples that demonstrated the different confetti animation.
- easy to make shapes you want.

## Getting started

Import the package

```dart
import 'package:flutter_confetti/flutter_confetti.dart';
```
Launch confetti by using the static method `Confetti.launch`:

```dart
Confetti.launch(
  context,
  options: const ConfettiOptions(
      particleCount: 100, spread: 70, y: 0.6)
);
```

## Thanks

The package was totally inspired by [canvas-confetti](https://github.com/catdad/canvas-confetti), a wonderful confetti animation in the browser,
I just do a little work to make it in flutter.
