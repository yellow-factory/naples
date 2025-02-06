import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

//TODO: Començo a pensar que no són del tot útils i me les podria estalviar, per tal
//com estan no em dóna llibertat per escollir si el widget és amb estat o sense
//i tampoc és el aporta

abstract class EditBuilder<T> extends StatelessWidget {
  final T model;
  final FunctionOf2<Widget, bool, Widget> builder;

  const EditBuilder({
    required this.model,
    required this.builder,
    super.key,
  });
}

abstract class EditBuilder2<T, U> extends StatelessWidget {
  final T model1;
  final U model2;
  final FunctionOf2<Widget, bool, Widget> builder;

  const EditBuilder2({
    required this.model1,
    required this.model2,
    required this.builder,
    super.key,
  });
}
