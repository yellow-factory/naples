import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

abstract interface class Property<U> {
  String get label;
  String? get hint;
  bool get autofocus;
  PredicateOf0? get editable;
  FunctionOf0<U> get getProperty;
  ActionOf1<U>? get setProperty;
  FunctionOf1<U, String?>? get validator;
}

abstract class PropertyWidget<U> extends StatelessWidget implements Property<U> {
  const PropertyWidget({super.key});
}

abstract class PropertyStatefulWidget<U> extends StatefulWidget implements Property<U> {
  const PropertyStatefulWidget({super.key});
}

mixin PropertyMixin<U> on Property<U> {
  bool get initialValid => validator == null ? true : validator!(getProperty()) == null;
  bool get enabled => ifNotNullPredicateOf0(editable, setProperty == null ? false : true);
}
