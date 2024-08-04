import 'dart:async';
import 'dart:math';

import 'package:example/code_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

// late final Highlighter _dartLightHighlighter;
late final Highlighter _dartDarkHighlighter;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Initialize the highlighter.
  await Highlighter.initialize([
    'dart',
  ]);

  // Load the default light theme and create a highlighter.
  // var lightTheme = await HighlighterTheme.loadLightTheme();
  // _dartLightHighlighter = Highlighter(
  //   language: 'dart',
  //   theme: lightTheme,
  // );

  // Load the default dark theme and create a highlighter.
  var darkTheme = await HighlighterTheme.loadDarkTheme();
  _dartDarkHighlighter = Highlighter(
    language: 'dart',
    theme: darkTheme,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(title: const Text('🎉 Flutter Confetti🎉 ')),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.extent(
              maxCrossAxisExtent: 500,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                CodeBlock(
                  buttonText: 'Basic Cannon',
                  highlighter: _dartDarkHighlighter,
                  onTap: () {
                    ///BEGIN

                    Confetti.launch(
                      context,
                      options: const ConfettiOptions(
                          particleCount: 100, spread: 70, y: 0.6),
                    );

                    ///END
                  },
                ),
                CodeBlock(
                  buttonText: 'Random Direction',
                  highlighter: _dartDarkHighlighter,
                  onTap: () {
                    ///BEGIN
                    double randomInRange(double min, double max) {
                      return min + Random().nextDouble() * (max - min);
                    }

                    Confetti.launch(
                      context,
                      options: ConfettiOptions(
                          angle: randomInRange(55, 125),
                          spread: randomInRange(50, 70),
                          particleCount: randomInRange(50, 100).toInt(),
                          y: 0.6),
                    );

                    ///END
                  },
                ),
                CodeBlock(
                  buttonText: 'Fireworks',
                  highlighter: _dartDarkHighlighter,
                  onTap: () {
                    ///BEGIN
                    double randomInRange(double min, double max) {
                      return min + Random().nextDouble() * (max - min);
                    }

                    int total = 60;
                    int progress = 0;

                    Timer.periodic(const Duration(milliseconds: 250), (timer) {
                      progress++;

                      if (progress >= total) {
                        timer.cancel();
                        return;
                      }

                      int count = ((1 - progress / total) * 50).toInt();

                      Confetti.launch(
                        context,
                        options: ConfettiOptions(
                            particleCount: count,
                            startVelocity: 30,
                            spread: 360,
                            ticks: 60,
                            x: randomInRange(0.1, 0.3),
                            y: Random().nextDouble() - 0.2),
                      );
                      Confetti.launch(
                        context,
                        options: ConfettiOptions(
                            particleCount: count,
                            startVelocity: 30,
                            spread: 360,
                            ticks: 60,
                            x: randomInRange(0.7, 0.9),
                            y: Random().nextDouble() - 0.2),
                      );
                    });

                    ///END
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
