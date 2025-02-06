import 'package:flutter/material.dart';

typedef HoverBuilder = Widget Function(bool hover);

class OnHoverWidget extends StatefulWidget {
  final HoverBuilder builder;
  const OnHoverWidget({super.key, required this.builder});

  @override
  State<OnHoverWidget> createState() => _OnHoverWidgetState();
}

class _OnHoverWidgetState extends State<OnHoverWidget> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return InkWell(
      onTap: () {},
      onHover: (value) {
        setState(() {
          hover = value;
        });
      },
      child: widget.builder(hover),
    );
  }
}
