import 'package:flutter/material.dart';

class ActionWrap{
  final String title;
  final Function action;
  ActionWrap({this.title, this.action});
}

class ActionsWidget extends StatelessWidget {
  
  final Widget child;
  final List<ActionWrap> actions;

  ActionsWidget({Key key, this.child, this.actions}):super(key: key);

  @override
  Widget build(BuildContext context) {    
    return 
      Column(
        children: <Widget>[
          child,
          Container(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 6,
              textDirection: TextDirection.rtl,
              alignment: WrapAlignment.end,
              children: 
              [
                for(var a in actions)
                  RaisedButton(
                    child: Text(a.title),
                    onPressed: () {
                      if(a.action!=null) a.action();
                    },
                  ),
              ],
            )
          )
        ]
      );
  }
}