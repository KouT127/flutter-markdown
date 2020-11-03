import 'package:flutter/widgets.dart';

abstract class MarkDownFormatter {
  MarkDownFormatter({
    this.controller,
  });

  final TextEditingController controller;

  String get text => controller.text;

  int get start => controller.selection.start;

  int get end => controller.selection.end;

  String get selectedText {
    final start = controller.selection.start;
    final end = controller.selection.end;
    if (start == end) {
      return "";
    }
    return controller.text.substring(start, end);
  }

  void format();
}

class BoldFormatter extends MarkDownFormatter {
  BoldFormatter({
    TextEditingController controller,
  }) : super(
          controller: controller,
        );

  int _offset = 2;

  @override
  void format() {
    controller.text =
        controller.text.replaceRange(start, end, "**$selectedText**");
    controller.selection = controller.selection.copyWith(
      baseOffset: _offset + start,
      extentOffset: end + _offset,
    );
  }
}

class ItalicFormatter extends MarkDownFormatter {
  ItalicFormatter({
    TextEditingController controller,
  }) : super(
          controller: controller,
        );

  int _offset = 1;

  @override
  void format() {
    controller.text =
        controller.text.replaceRange(start, end, "*$selectedText*");
    controller.selection = controller.selection.copyWith(
      baseOffset: _offset + start,
      extentOffset: end + _offset,
    );
  }
}

class HeadingOneFormatter extends MarkDownFormatter {
  HeadingOneFormatter({
    TextEditingController controller,
  }) : super(
          controller: controller,
        );

  int _offset = 2;

  @override
  void format() {
    controller.text =
        controller.text.replaceRange(start, end, "# $selectedText");
    controller.selection = controller.selection.copyWith(
      baseOffset: _offset + start,
      extentOffset: end + _offset,
    );
  }
}

class HeadingTwoFormatter extends MarkDownFormatter {
  HeadingTwoFormatter({
    TextEditingController controller,
  }) : super(
          controller: controller,
        );

  int _offset = 3;

  @override
  void format() {
    controller.text =
        controller.text.replaceRange(start, end, "## $selectedText");
    controller.selection = controller.selection.copyWith(
      baseOffset: _offset + start,
      extentOffset: end + _offset,
    );
  }
}

class CodeBlocksFormatter extends MarkDownFormatter {
  CodeBlocksFormatter({
    TextEditingController controller,
  }) : super(
          controller: controller,
        );

  int _offset = 5;

  @override
  void format() {
    controller.text =
        controller.text.replaceRange(start, end, "```\n$selectedText\n```");
    controller.selection = controller.selection.copyWith(
      baseOffset: _offset + start,
      extentOffset: end + _offset,
    );
  }
}
