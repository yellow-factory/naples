import 'package:flutter/material.dart';

class CardTopBar extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget> actions;
  const CardTopBar({
    Key? key,
    required this.child,
    this.title,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(children: <Widget>[
        ListTile(
          //tileColor: Colors.grey.shade200,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              if (title != null) Text(title!),
              Expanded(
                child: OverflowBar(
                  alignment: MainAxisAlignment.end,
                  spacing: 5,
                  overflowSpacing: 5,
                  overflowAlignment: OverflowBarAlignment.end,
                  children: actions,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          indent: 5,
          endIndent: 5,
        ),
        Expanded(child: child)
      ]),
    );
  }
}
