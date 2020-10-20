import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/view_property.dart';
import 'package:naples/src/view_models/edit/properties/widgets/container_widget.dart';
import 'package:naples/steps.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

class ContainerProperty extends ViewProperty {
  final FunctionOf1<BuildContext, String> label;
  final Widget container;

  ContainerProperty(
    this.label,
    this.container, {
    int flex = 1,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
  }) : super(
          flex: flex,
          isVisible: isVisible,
        );

  @override
  Widget get widget => ChangeNotifierProvider<ContainerProperty>.value(
        value: this,
        child: ContainerPropertyWidget(),
      );
}

//TODO: We may need a property inheriting from ContainerProperty which expects a ListViewModel instead a plain ViewModel,
//so we can prepare a widget accordingly, with create and select, for example, or maybe these properties have to be part of the
//view,with a floating
