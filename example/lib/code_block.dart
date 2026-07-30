import 'dart:ui';

import 'package:example/code_block.g.dart';
import 'package:example/demo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class CodeBlock extends StatefulWidget {
  final Highlighter highlighter;
  final String buttonText;
  final VoidCallback onTap;
  final String? tip;
  final Widget? otherButton;
  final Widget? overWidget;

  const CodeBlock({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.otherButton,
    required this.highlighter,
    this.tip,
    this.overWidget,
  });

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  static final Map<String, TextSpan> _spanCache = {};
  static const _maxBlur = 16.0;
  static const _maxFrost = 0.55;

  late final String _codesStr;
  late final TextSpan _codeSpan;
  late final AnimationController _reveal;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _codesStr = getCodeByTitle(widget.buttonText) as String? ?? '';
    _codeSpan = _spanCache.putIfAbsent(
      widget.buttonText,
      () => widget.highlighter.highlight(_codesStr),
    );
    _reveal = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
      reverseDuration: const Duration(milliseconds: 360),
    );
  }

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  void _showCode() => _reveal.forward();

  void _hideCode() => _reveal.reverse();

  void _play(BuildContext context) {
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RepaintBoundary(
      child: Container(
        decoration: const BoxDecoration(
          color: DemoColors.surface,
        ),
        foregroundDecoration: const BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(
              color: Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
        ),
        child: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ColoredBox(
                color: DemoColors.surface,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.buttonText,
                                style: DemoTextStyles.cardTitle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.tip != null)
                              IconButton(
                                tooltip: widget.tip!,
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.help_outline_rounded,
                                  size: 18,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Play',
                        onPressed: () => _play(context),
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          size: 22,
                        ),
                      ),
                      if (widget.otherButton != null) widget.otherButton!,
                      Builder(
                        builder: (buttonContext) {
                          return MouseRegion(
                            onEnter: (_) => _showCode(),
                            onExit: (_) => _hideCode(),
                            child: IconButton(
                              tooltip: 'Copy code',
                              onPressed: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: _codesStr));
                                if (!buttonContext.mounted) return;

                                final box = buttonContext.findRenderObject()
                                    as RenderBox?;
                                if (box != null && box.hasSize) {
                                  final origin = box.localToGlobal(
                                    box.size.center(Offset.zero),
                                  );
                                  final screen =
                                      MediaQuery.sizeOf(buttonContext);
                                  Confetti.launch(
                                    buttonContext,
                                    options: ConfettiOptions(
                                      particleCount: 16,
                                      spread: 60,
                                      startVelocity: 16,
                                      gravity: 1.4,
                                      scalar: 0.65,
                                      particleDuration: const Duration(
                                        milliseconds: 800,
                                      ),
                                      x: origin.dx / screen.width,
                                      y: origin.dy / screen.height,
                                    ),
                                  );
                                }
                              },
                              icon:
                                  const Icon(Icons.copy_rounded, size: 18),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (_) => _showCode(),
                  onPointerUp: (_) => _hideCode(),
                  onPointerCancel: (_) => _hideCode(),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                        color: DemoColors.codeBg,
                        child: AnimatedBuilder(
                          animation: _reveal,
                          builder: (context, child) {
                            final t = Curves.easeOutCubic
                                .transform(_reveal.value);
                            final sigma = _maxBlur * (1 - t);
                            final frost = _maxFrost * (1 - t);

                            Widget content = child!;
                            if (sigma > 0.4) {
                              content = ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: sigma,
                                  sigmaY: sigma,
                                  tileMode: TileMode.clamp,
                                ),
                                child: content,
                              );
                            }

                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                content,
                                if (frost > 0.01)
                                  IgnorePointer(
                                    child: ColoredBox(
                                      color: DemoColors.codeBg
                                          .withValues(alpha: frost),
                                    ),
                                  ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  height: 28,
                                  child: IgnorePointer(
                                    child: Opacity(
                                      opacity: t,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              DemoColors.codeBg
                                                  .withValues(alpha: 0),
                                              DemoColors.codeBg,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          // NeverScrollable: keep layout for tall snippets, but
                          // don't compete with the page scroll for wheel/trackpad.
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            padding:
                                const EdgeInsets.fromLTRB(16, 14, 16, 28),
                            child: Text.rich(
                              _codeSpan,
                              style: DemoTextStyles.code,
                            ),
                          ),
                        ),
                      ),
                      if (widget.overWidget != null) widget.overWidget!,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
