import 'package:flutter/material.dart';
import 'package:yellow_naples/view_model.dart';
import 'package:provider/provider.dart';

class DynamicFormWidget extends StatelessWidget {
  DynamicFormWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var properties =
        context.select<GetSetViewModel, Iterable<EditableViewModelProperty>>(
            (x) => x.properties);

    return Form(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: properties.map((e) => e.widget).toList()),
      autovalidate: true,
    );
  }
}
