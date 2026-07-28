import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const options = ConfettiOptions(
    x: 0.25,
    y: 0.75,
    particleCount: 1,
    ticks: 1000,
  );

  Positioned findLauncher(WidgetTester tester) {
    return tester.widget<Positioned>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Positioned && widget.width == 2 && widget.height == 2,
      ),
    );
  }

  testWidgets('launch uses the nearest overlay size', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 200,
            height: 300,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => TextButton(
                    onPressed: () => Confetti.launch(
                      context,
                      options: options,
                    ),
                    child: const Text('launch'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('launch'));
    await tester.pump();

    expect(findLauncher(tester).left, 50);
    expect(findLauncher(tester).top, 225);
  });

  testWidgets('custom insertion uses the target overlay size', (tester) async {
    final overlayKey = GlobalKey<OverlayState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 200,
                height: 300,
                child: Overlay(key: overlayKey),
              ),
            ),
            Builder(
              builder: (context) => TextButton(
                onPressed: () => Confetti.launch(
                  context,
                  options: options,
                  insertInOverlay: overlayKey.currentState!.insert,
                ),
                child: const Text('launch'),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('launch'));
    await tester.pump();

    expect(findLauncher(tester).left, 50);
    expect(findLauncher(tester).top, 225);
  });

  testWidgets('launch position follows overlay size changes', (tester) async {
    late StateSetter resize;
    var overlayWidth = 200.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: StatefulBuilder(
            builder: (context, setState) {
              resize = setState;
              return SizedBox(
                width: overlayWidth,
                height: 300,
                child: Overlay(
                  initialEntries: [
                    OverlayEntry(
                      builder: (context) => TextButton(
                        onPressed: () => Confetti.launch(
                          context,
                          options: options,
                        ),
                        child: const Text('launch'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('launch'));
    await tester.pump();
    expect(findLauncher(tester).left, 50);

    resize(() => overlayWidth = 400);
    await tester.pump();

    expect(findLauncher(tester).left, 100);
  });
}
