import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

abstract class EditBuilder<T> extends StatelessWidget {
  final T model;
  final FunctionOf2<Widget, bool, Widget> builder;

  EditBuilder({
    required this.model,
    required this.builder,
    Key? key,
  }) : super(key: key);
}

abstract class EditBuilder2<T, U> extends StatelessWidget {
  final T model1;
  final U model2;
  final FunctionOf2<Widget, bool, Widget> builder;

  EditBuilder2({
    required this.model1,
    required this.model2,
    required this.builder,
    Key? key,
  }) : super(key: key);
}
