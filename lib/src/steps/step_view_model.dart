import 'package:flutter/material.dart';
import 'package:naples/navigation.dart';
import 'package:naples/src/view_models/edit/dynamic_form.dart';
import 'package:naples/src/view_models/edit/get_loader.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';
import 'package:naples/src/view_models/edit/properties/view_property.dart';
import 'package:naples/widgets/distribution_widget.dart';
import 'package:navy/navy.dart';

class StepViewModel<T> extends StatelessWidget {
  final NavigationModel navigationModel;
  final FunctionOf0<Future<T>> get;
  final FunctionOf1<T, Future<void>> set;
  final FunctionOf1<T, Iterable<ViewProperty>> getLayoutMembers;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;

  StepViewModel({
    @required this.navigationModel,
    @required this.get,
    this.set,
    @required this.getLayoutMembers,
    this.fixed = 1,
    this.maxFlex = 1,
    this.normalize = true,
    this.distribution = DistributionType.LeftToRight,
    Key key,
  }) : super(key: key);

  Iterable<ViewProperty> visibleProperties(T t) => getLayoutMembers(t)
      .whereType<ViewProperty>()
      .where((element) => element.isVisible == null || element.isVisible());

  bool valid(Iterable<ViewProperty> properties) {
    return properties.whereType<ModelProperty>().every((element) => element.validate() == null);
  }

  @override
  Widget build(BuildContext context) {
    return GetLoader<T>(
      get: get,
      builder: (item, loading) {
        final properties = visibleProperties(item);
        return DynamicForm(
          fixed: fixed,
          children: properties,
          maxFlex: maxFlex,
          normalize: normalize,
          distribution: distribution,
        );
      },
    );
  }
}
