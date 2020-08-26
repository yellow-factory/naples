import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../snack.dart';

class SnackModelWidget extends StatelessWidget {

  final Widget child;  

  SnackModelWidget({@required this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var message = context.select<SnackModel, String>((sn) => sn.message);  
    if(message!=null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message))); 
        
      });
      Provider.of<SnackModel>(context, listen: false).clear();
    }
    return child;
  }

}