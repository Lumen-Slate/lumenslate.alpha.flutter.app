import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HighlightAbleText extends StatelessWidget {
  final String text;
  final List<HighlightSegment> highlights;
  final TextStyle defaultTextStyle;

  const HighlightAbleText({
    super.key,
    required this.text,
    required this.highlights,
    this.defaultTextStyle = const TextStyle(color: Colors.black),
  });

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> spans = [];
    int currentIndex = 0;

    for (final highlight in highlights) {
      // Skip out-of-range highlights
      if (highlight.start < 0 || highlight.start >= text.length || highlight.end > text.length || highlight.start >= highlight.end) {
        continue;
      }

      // Add non-highlighted text before the current highlight
      if (currentIndex < highlight.start) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, highlight.start),
          style: defaultTextStyle,
        ));
      }

      // Add the highlighted segment with rounded background
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: highlight.onTap ??
                    () {
                  Logger().i('Tapped on: "${text.substring(highlight.start, highlight.end)}"');
                },
            child: Container(
              decoration: BoxDecoration(
                color: highlight.highlightColor,
                borderRadius: BorderRadius.circular(highlight.borderRadius),
              ),
              padding: highlight.padding,
              child: Text(
                text.substring(highlight.start, highlight.end),
                style: highlight.style,
              ),
            ),
          ),
        ),
      ));

      // Update the current index
      currentIndex = highlight.end;
    }

    // Add any remaining non-highlighted text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: defaultTextStyle,
      ));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: defaultTextStyle, // Fallback style
      ),
    );
  }
}

class HighlightSegment {
  final int start;
  final int end;
  final TextStyle style;
  final Color highlightColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  HighlightSegment({
    required this.start,
    required this.end,
    required this.style,
    this.highlightColor = Colors.transparent,
    this.borderRadius = 14.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.onTap,
  });
}