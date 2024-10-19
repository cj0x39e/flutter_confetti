import 'package:example/code_block.g.dart';
import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:flutter/services.dart';

class CodeBlock extends StatelessWidget {
  final Highlighter highlighter;
  final String buttonText;
  final Function() onTap;
  final String? tip;
  final Widget? otherButton;
  const CodeBlock({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.otherButton,
    required this.highlighter,
    this.tip,
  });

  @override
  Widget build(BuildContext context) {
    const double width = 500;
    final codesStr = getCodeByTitle(buttonText);

    return SizedBox(
      width: width,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton(onPressed: onTap, child: Text(buttonText)),
              if (otherButton != null) ...[
                const SizedBox(width: 8),
                otherButton!
              ],
              const SizedBox(width: 8),
              IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: codesStr));
                  },
                  icon: const Icon(Icons.copy_all_rounded)),
              if (tip != null)
                Expanded(
                    child: Text(
                  tip ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 10),
                ))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minWidth: width),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border:
                    Border.all(width: 1, color: Theme.of(context).primaryColor),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text.rich(
                    highlighter.highlight(codesStr),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
