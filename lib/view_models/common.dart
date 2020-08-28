import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/view_models/view_model.dart';
import 'package:yellow_naples/navigation.dart';

abstract class StepViewModel<T> extends GetSetViewModel<T> {
  StepViewModel(BuildContext c) : super(c);

  Future<void> next();
  Future<void> previous() async {
    var back = await Provider.of<NavigationModel>(context, listen: false).back();
    print('Cancelling: $back');
  }
}
