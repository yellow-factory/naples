import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:navy/navy.dart';

abstract class Refreshable implements Initialized {
  Future<void> refresh();
}

abstract class ViewModel extends ChangeNotifier with OneTimeInitializable1<BuildContext> {
  BuildContext context;

  @override
  Future<void> init1(BuildContext context) async {
    this.context = context;
  }

  T getProvided<T>() => Provider.of<T>(context, listen: false);

  String get title;
  Widget get widget;
}

abstract class ViewModelOf<T> extends ViewModel {
  T model;
  ViewModelOf();
}

