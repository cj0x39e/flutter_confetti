import 'dart:async';
import 'dart:math';

import 'package:example/code_block.dart';
import 'package:example/demo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:url_launcher/url_launcher.dart';

late final Highlighter _dartHighlighter;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bundled fonts in example/google_fonts/ load first (no network swap).
  // Await every weight we use so the first frame already has final metrics.
  await GoogleFonts.pendingFonts([
    GoogleFonts.syne(),
    GoogleFonts.syne(fontWeight: FontWeight.w700),
    GoogleFonts.dmSans(),
    GoogleFonts.dmSans(fontWeight: FontWeight.w500),
    GoogleFonts.dmSans(fontWeight: FontWeight.w600),
    GoogleFonts.dmSans(fontWeight: FontWeight.w700),
    GoogleFonts.jetBrainsMono(),
  ]);

  await Highlighter.initialize(['dart']);

  final lightTheme = await HighlighterTheme.loadLightTheme();
  _dartHighlighter = Highlighter(
    language: 'dart',
    theme: lightTheme,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final controller = ConfettiController();
  List<ConfettiController> killableControllerList = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Confetti',
      debugShowCheckedModeBanner: false,
      theme: buildDemoTheme(),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: DemoColors.canvas,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 1100
                    ? 3
                    : width >= 720
                        ? 2
                        : 1;
                const gap = 16.0;

                return Scrollbar(
                  thumbVisibility: true,
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(child: _Header()),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: gap,
                            mainAxisSpacing: gap,
                            mainAxisExtent: 320,
                          ),
                          delegate: SliverChildListDelegate(
                            _demoCards(context),
                            addAutomaticKeepAlives: true,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: _Footer()),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _demoCards(BuildContext context) {
    return [
      CodeBlock(
        buttonText: 'Basic Cannon',
        highlighter: _dartHighlighter,
        onTap: () {
          ///BEGIN
          Confetti.launch(
            context,
            options: const ConfettiOptions(
                particleCount: 100,
                spread: 70,
                particleDuration: Duration(seconds: 3),
                y: 0.6),
          );

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Random Direction',
        highlighter: _dartHighlighter,
        onTap: () {
          ///BEGIN
          double randomInRange(double min, double max) {
            return min +
                Random().nextDouble() * (max - min);
          }

          Confetti.launch(
            context,
            options: ConfettiOptions(
                angle: randomInRange(55, 125),
                spread: randomInRange(50, 70),
                particleCount:
                    randomInRange(50, 100).toInt(),
                y: 0.6),
          );

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Fireworks',
        highlighter: _dartHighlighter,
        onTap: () {
          ///BEGIN
          double randomInRange(double min, double max) {
            return min +
                Random().nextDouble() * (max - min);
          }

          int total = 60;
          int progress = 0;

          Timer.periodic(
              const Duration(milliseconds: 250),
              (timer) {
            progress++;

            if (progress >= total) {
              timer.cancel();
              return;
            }

            int count =
                ((1 - progress / total) * 50).toInt();

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
      CodeBlock(
        buttonText: 'Stars',
        highlighter: _dartHighlighter,
        onTap: () {
          ///BEGIN

          const options = ConfettiOptions(
              spread: 360,
              ticks: 50,
              gravity: 0,
              decay: 0.94,
              startVelocity: 30,
              colors: [
                Color(0xffFFE400),
                Color(0xffFFBD00),
                Color(0xffE89400),
                Color(0xffFFCA6C),
                Color(0xffFDFFB8)
              ]);

          shoot() {
            Confetti.launch(context,
                options: options.copyWith(
                    particleCount: 40, scalar: 1.2),
                particleBuilder: (index) => Star());
            Confetti.launch(context,
                options: options.copyWith(
                  particleCount: 10,
                  scalar: 0.75,
                ),
                particleBuilder: (index) => Star());
          }

          Timer(Duration.zero, shoot);
          Timer(const Duration(milliseconds: 100),
              shoot);
          Timer(const Duration(milliseconds: 200),
              shoot);

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Emoji',
        tip: 'First run may pause briefly while the emoji font downloads.',
        highlighter: _dartHighlighter,
        onTap: () {
          ///BEGIN

          const options = ConfettiOptions(
            spread: 360,
            ticks: 50,
            gravity: 0,
            decay: 0.94,
            startVelocity: 30,
          );

          shoot() {
            Confetti.launch(context,
                options: options.copyWith(
                  particleCount: 40,
                ),
                particleBuilder: (index) => Emoji(
                    emoji: '🍄',
                    textStyle:
                        GoogleFonts.notoColorEmoji()));
            Confetti.launch(context,
                options: options.copyWith(
                  particleCount: 10,
                ),
                particleBuilder: (index) => Emoji(
                      emoji: '️⚽',
                      textStyle:
                          GoogleFonts.notoColorEmoji(),
                    ));
          }

          Timer(Duration.zero, shoot);
          Timer(const Duration(milliseconds: 200),
              shoot);
          Timer(const Duration(milliseconds: 400),
              shoot);

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Snow',
        highlighter: _dartHighlighter,
        onTap: () {
          ///BEGIN

          const colors = [
            Color(0xFF5BA3E8),
            Color(0xFF7EB6FF),
            Color(0xFF9ECCF5),
            Color(0xFF4A90D9),
          ];

          // ~12 seconds of snowfall.
          int total = 120;
          int progress = 0;

          ConfettiController? controller;
          bool isDone = false;

          Timer.periodic(
              const Duration(milliseconds: 100),
              (timer) {
            progress++;

            if (progress >= total) {
              timer.cancel();
              isDone = true;
              return;
            }

            if (controller == null) {
              controller = Confetti.launch(
                context,
                options: const ConfettiOptions(
                  particleCount: 2,
                  // No launch speed — gravity alone pulls them down.
                  startVelocity: 0,
                  spread: 360,
                  ticks: 1000,
                  fadeOut: false,
                  gravity: 0.4,
                  driftVariance: 0.6,
                  scalar: 0.7,
                  y: -0.05,
                  randomX: true,
                  colors: colors,
                ),
                particleBuilder: (index) =>
                    Snowflake(),
                onFinished: (overlayEntry) {
                  if (isDone) {
                    overlayEntry.remove();
                  }
                },
              );
            } else {
              controller!.launch();
            }
          });

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'School Pride',
        highlighter: _dartHighlighter,
        onTap: () {
          ///BEGIN

          const colors = [
            Color(0xffbb0000),
            Color(0xffffffff),
          ];

          int frameTime = 1000 ~/ 24;
          int total = 15 * 1000 ~/ frameTime;
          int progress = 0;

          ConfettiController? controller1;
          ConfettiController? controller2;
          bool isDone = false;

          Timer.periodic(
              Duration(milliseconds: frameTime),
              (timer) {
            progress++;

            if (progress >= total) {
              timer.cancel();
              isDone = true;
              return;
            }
            if (controller1 == null) {
              controller1 = Confetti.launch(
                context,
                options: const ConfettiOptions(
                    particleCount: 2,
                    angle: 60,
                    spread: 55,
                    x: 0,
                    colors: colors),
                onFinished: (overlayEntry) {
                  if (isDone) {
                    overlayEntry.remove();
                  }
                },
              );
            } else {
              controller1!.launch();
            }

            if (controller2 == null) {
              controller2 = Confetti.launch(
                context,
                options: const ConfettiOptions(
                    particleCount: 2,
                    angle: 120,
                    spread: 55,
                    x: 1,
                    colors: colors),
                onFinished: (overlayEntry) {
                  if (isDone) {
                    overlayEntry.remove();
                  }
                },
              );
            } else {
              controller2!.launch();
            }
          });

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Kill Mid-flight',
        tip: 'Play, then press Kill to stop particles mid-flight.',
        highlighter: _dartHighlighter,
        onTap: () {
          ///BEGIN

          final controller = Confetti.launch(
            context,
            options: const ConfettiOptions(
                particleCount: 100,
                spread: 70,
                y: 0.6),
          );

          /// call the kill method to kill the confetti
          /// controller.kill();

          ///END

          killableControllerList.add(controller);
        },
        otherButton: IconButton(
          tooltip: 'Kill',
          onPressed: () {
            for (var controller in killableControllerList) {
              controller.kill();
            }
          },
          icon: const Icon(Icons.stop_rounded, size: 22),
        ),
      ),
      CodeBlock(
        buttonText: 'Not Full Screen',
        highlighter: _dartHighlighter,
        onTap: () {
          ///BEGIN
          controller.launch();

          // Wrap the Confetti widget in a Container.
          // Container(
          //   child: ClipPath(
          //     child: Confetti(
          //       controller: controller,
          //       options: const ConfettiOptions(
          //           particleCount: 100, spread: 70, y: 1),
          //     ),
          //   ),
          // );

          ///END
        },
        overWidget: Positioned.fill(
          child: IgnorePointer(
            child: Confetti(
              controller: controller,
              options: const ConfettiOptions(
                  particleCount: 100,
                  spread: 70,
                  y: 1),
            ),
          ),
        ),
      ),

    ];
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  static final _github =
      Uri.parse('https://github.com/tao-zhi-1992/flutter_confetti');
  static final _pub =
      Uri.parse('https://pub.dev/packages/flutter_confetti');

  static final _muted = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: DemoColors.inkMuted,
  );

  static final _link = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: DemoColors.ink,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 0,
        runSpacing: 8,
        children: [
          Text('v0.9.0', style: _muted),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('·', style: _muted.copyWith(color: DemoColors.line)),
          ),
          Text('tao-zhi', style: _muted),
          const SizedBox(width: 18),
          _FooterLink(label: 'GitHub', uri: _github, style: _link),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('/', style: _muted.copyWith(fontSize: 11)),
          ),
          _FooterLink(label: 'pub.dev', uri: _pub, style: _link),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.uri,
    required this.style,
  });

  final String label;
  final Uri uri;
  final TextStyle style;

  Future<void> _open() async {
    await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _open,
        child: Text(label, style: style),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final titleSize = width < 400
        ? 42.0
        : width < 720
            ? 52.0
            : 64.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Confetti.launch(
              context,
              options: const ConfettiOptions(
                particleCount: 55,
                spread: 80,
                startVelocity: 28,
                y: 0.14,
                particleDuration: Duration(seconds: 2),
              ),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'FLUTTER',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 6.5,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.8
                    ..strokeJoin = StrokeJoin.round
                    ..color = const Color(0xFFB0B5BE),
                ),
              ),
              const SizedBox(height: 8),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      DemoColors.cyan,
                      DemoColors.violet,
                      DemoColors.rose,
                      DemoColors.amber,
                      DemoColors.magenta,
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  'Confetti',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.syne(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: -2.2,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = titleSize * 0.045
                      ..strokeJoin = StrokeJoin.round
                      ..color = Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const _ConfettiRule(),
            ],
          ),
        ),
      ),
    );
  }
}

/// A quiet underline of confetti shapes — brand mark, not decoration spam.
class _ConfettiRule extends StatelessWidget {
  const _ConfettiRule();

  @override
  Widget build(BuildContext context) {
    const pieces = <(Color, double, int)>[
      (DemoColors.cyan, -0.25, 0),
      (DemoColors.violet, 0.35, 1),
      (DemoColors.rose, -0.15, 2),
      (Color(0xFFFFC933), 0.4, 3),
      (DemoColors.amber, -0.3, 0),
      (DemoColors.magenta, 0.2, 1),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < pieces.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Transform.rotate(
            angle: pieces[i].$2,
            child: _ConfettiChip(
              color: pieces[i].$1,
              kind: pieces[i].$3,
            ),
          ),
        ],
      ],
    );
  }
}

class _ConfettiChip extends StatelessWidget {
  const _ConfettiChip({required this.color, required this.kind});

  final Color color;
  final int kind;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(10, 10),
      painter: _ChipPainter(color: color, kind: kind),
    );
  }
}

class _ChipPainter extends CustomPainter {
  const _ChipPainter({required this.color, required this.kind});

  final Color color;
  final int kind;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeJoin = StrokeJoin.miter;
    final c = Offset(size.width / 2, size.height / 2);
    final s = size.shortestSide / 2;

    switch (kind % 4) {
      case 0:
        canvas.drawRect(
          Rect.fromCenter(center: c, width: s * 2.1, height: s * 1.1),
          paint,
        );
      case 1:
        canvas.drawCircle(c, s * 0.85, paint);
      case 2:
        final path = Path()
          ..moveTo(c.dx, c.dy - s)
          ..lineTo(c.dx + s * 0.9, c.dy + s * 0.7)
          ..lineTo(c.dx - s * 0.9, c.dy + s * 0.7)
          ..close();
        canvas.drawPath(path, paint);
      default:
        // Five-point star outline.
        final star = Path();
        for (var i = 0; i < 10; i++) {
          final radius = i.isEven ? s : s * 0.42;
          final angle = -pi / 2 + i * pi / 5;
          final point = Offset(
            c.dx + cos(angle) * radius,
            c.dy + sin(angle) * radius,
          );
          if (i == 0) {
            star.moveTo(point.dx, point.dy);
          } else {
            star.lineTo(point.dx, point.dy);
          }
        }
        star.close();
        canvas.drawPath(star, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChipPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.kind != kind;
}
