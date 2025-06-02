import 'package:flutter/material.dart';

class HighlightTextEditingController extends TextEditingController {
  final List<Range> highlightRanges;
  final Function(int start, int end)? onTextSelectionChanged;

  HighlightTextEditingController({
    required this.highlightRanges,
    this.onTextSelectionChanged,
  }) : super() {
    // Add a listener to detect text selection changes
    this.addListener(_onSelectionChange);
  }

  // Callback to be triggered when the selection changes
  void _onSelectionChange() {
    final selection = this.selection;
    if (selection != null && selection.isValid) {
      // Call the provided callback with the start and end indices
      onTextSelectionChanged?.call(selection.start, selection.end);
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    bool? withComposing,
  }) {
    style ??= const TextStyle();
    final children = <InlineSpan>[];

    int currentIndex = 0;

    for (final range in highlightRanges) {
      // Skip this range if its end index exceeds the current text length
      if (range.end > text.length) {
        continue;
      }

      // Add non-highlighted text before the current highlight range
      if (currentIndex < range.start) {
        children.add(TextSpan(
          text: text.substring(currentIndex, range.start),
          style: style,
        ));
      }

      // Add highlighted text for the current range as a WidgetSpan
      children.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
          child: Text(
            text.substring(range.start, range.end),
            style: style,
          ),
        ),
      ));

      // Update the current index to the end of the highlighted range
      currentIndex = range.end;
    }

    // Add any remaining non-highlighted text after the last highlight range
    if (currentIndex < text.length) {
      children.add(TextSpan(
        text: text.substring(currentIndex),
        style: style,
      ));
    }

    return TextSpan(style: style, children: children);
  }
}

class Range {
  final int start;
  final int end;

  Range(this.start, this.end);
}
