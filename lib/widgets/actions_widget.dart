import 'package:flutter/material.dart';

class ActionWrap {
  final String title;
  final Function action;
  ActionWrap({this.title, this.action});
}

class ActionsWidget extends StatelessWidget {
  final List<ActionWrap> actions;

  ActionsWidget({Key key, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: [
        for (var a in actions.reversed)
          RaisedButton(
            child: Text(a.title),
            onPressed: () {
              if (a.action != null) a.action();
            },
          ),
      ],
    );

    // return Container(
    //     alignment: Alignment.centerRight,
    //     child: Wrap(
    //       spacing: 6,
    //       textDirection: TextDirection.rtl,
    //       alignment: WrapAlignment.end,
    //       children: [
    //         for (var a in actions)
    //           RaisedButton(
    //             child: Text(a.title),
    //             onPressed: () {
    //               if (a.action != null) a.action();
    //             },
    //           ),
    //       ],
    //     ));
  }
}
