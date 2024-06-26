import 'package:flutter/material.dart';

class CardTopBar extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget> actions;
  final List<Widget> filters;
  const CardTopBar({
    Key? key,
    required this.child,
    this.title,
    this.actions = const [],
    this.filters = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(children: <Widget>[
        ListTile(
          //tileColor: Colors.grey.shade200,
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
        const Divider(
          indent: 5,
          endIndent: 5,
        ),
        if (filters.isNotEmpty)
          ButtonBar(
            alignment: MainAxisAlignment.start,
            overflowButtonSpacing: 10,
            children: filters,
          ),
        Expanded(child: child)
      ]),
    );
  }
}
