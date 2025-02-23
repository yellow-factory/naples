import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

abstract interface class ModelProperty<U> {
  String get label;
  String? get hint;
  bool get autofocus;
  PredicateOf0? get editable;
  FunctionOf0<U> get getProperty;
  ActionOf1<U>? get setProperty;
  FunctionOf1<U, String?>? get validator;
}

abstract class ModelPropertyWidget<U> extends StatelessWidget implements ModelProperty<U> {
  const ModelPropertyWidget({super.key});
}

abstract class ModelPropertyStatefulWidget<U> extends StatefulWidget implements ModelProperty<U> {
  const ModelPropertyStatefulWidget({super.key});
}

mixin ModelPropertyMixin<U> on ModelProperty<U> {
  bool get initialValid => validator == null ? true : validator!(getProperty()) == null;
  bool get enabled => ifNotNullPredicateOf0(editable, setProperty == null ? false : true);
}
