import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_markdown/utilities/markdown_formatter.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:markdown/markdown.dart' as md;

class MarkDownEditor extends StatefulWidget {
  MarkDownEditor({
    this.controller,
  }) : assert(controller != null);

  final TextEditingController controller;

  @override
  _MarkDownEditorState createState() => _MarkDownEditorState();
}

class _MarkDownEditorState extends State<MarkDownEditor> {
  final scrollController = ScrollController();

  LinkedScrollControllerGroup _controllers;
  ScrollController _linesController;
  ScrollController _editorController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _linesController = _controllers.addAndGet();
    _editorController = _controllers.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
              right: 10,
            ),
            child: SizedBox(
              width: 20,
              child: ListView(
                controller: _linesController,
                children: [
                  ...List.generate(
                    widget.controller.text.split("\n").length,
                    (index) => Text(
                      "${index + 1}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: MarkDownToolBar(
                    controller: widget.controller,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    scrollController: _editorController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    minLines: 1,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarkDownToolBar extends StatelessWidget {
  MarkDownToolBar({
    this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        MarkDownToolItem.italic(
          controller: controller,
        ),
        MarkDownToolItem.bold(
          controller: controller,
        ),
        MarkDownToolItem.heading1(
          controller: controller,
        ),
        MarkDownToolItem.heading2(
          controller: controller,
        ),
        MarkDownToolItem.code(
          controller: controller,
        ),
      ],
    );
  }
}

class MarkDownToolItem extends StatelessWidget {
  factory MarkDownToolItem.bold({
    TextEditingController controller,
  }) {
    return MarkDownToolItem(
      icon: "B",
      onPressed: BoldFormatter(controller: controller).format,
    );
  }

  factory MarkDownToolItem.heading1({
    TextEditingController controller,
  }) {
    return MarkDownToolItem(
      icon: "h1",
      onPressed: HeadingOneFormatter(controller: controller).format,
    );
  }

  factory MarkDownToolItem.heading2({
    TextEditingController controller,
  }) {
    return MarkDownToolItem(
      icon: "h2",
      onPressed: HeadingTwoFormatter(controller: controller).format,
    );
  }

  factory MarkDownToolItem.italic({
    TextEditingController controller,
  }) {
    return MarkDownToolItem(
      icon: "I",
      onPressed: ItalicFormatter(controller: controller).format,
    );
  }

  factory MarkDownToolItem.code({
    TextEditingController controller,
  }) {
    return MarkDownToolItem(
      icon: "<>",
      onPressed: CodeBlocksFormatter(controller: controller).format,
    );
  }

  MarkDownToolItem({
    this.icon,
    this.onPressed,
  });

  // TODO: Replace icon
  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      height: 40,
      minWidth: 40,
      onPressed: onPressed,
      child: Text(icon),
    );
  }
}

class MarkdownPreviewView extends StatelessWidget {
  MarkdownPreviewView({
    this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final html = md.markdownToHtml(controller.text);
    return Html(
      style: {
        "body": Style(alignment: Alignment.topLeft),
        "code": Style(
          backgroundColor: Colors.grey.shade100,
        ),
      },
      data: "$html",
    );
  }
}
