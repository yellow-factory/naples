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
      child: Column(children: <Widget>[
        ListTile(
          tileColor: Colors.grey.shade200,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              if (title != null) Text(title!),
              ButtonBar(
                children: actions,
              ),
            ],
          ),
        ),
        Expanded(child: child)
      ]),
      elevation: 4,
    );
  }
}
