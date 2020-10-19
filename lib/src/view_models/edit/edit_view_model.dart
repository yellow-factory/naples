import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/src/view_models/edit/get_loader.dart';
import 'package:naples/src/view_models/edit/properties/view_property.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';
import 'package:naples/widgets/distribution_widget.dart';
import 'package:navy/navy.dart';

// class EditViewModel<T> extends StatefulWidget {
//   final FunctionOf0<Future<T>> get;
//   final List<ViewProperty> layoutMembers;
//   final int fixed;
//   final int maxFlex;
//   final bool normalize;
//   final DistributionType distribution;
//   final EdgeInsetsGeometry childPadding;

//   EditViewModel({
//     @required this.get,
//     @required this.layoutMembers,
//     this.fixed = 1,
//     this.maxFlex = 1,
//     this.normalize = true,
//     this.distribution = DistributionType.LeftToRight,
//     this.childPadding = const EdgeInsets.only(right: 10),
//     key,
//   }) : super(key: key);

//   @override
//   _EditViewModelState<T> createState() => _EditViewModelState<T>();
// }

// class _EditViewModelState<T> extends State<EditViewModel<T>> {
//   final _formKey = GlobalKey<FormState>();

//   Iterable<ViewProperty> get visibleProperties => widget.layoutMembers
//       .whereType<ViewProperty>()
//       .where((element) => element.isVisible == null || element.isVisible());

//   // Iterable<ModelProperty> get editableProperties => widget.layoutMembers
//   //     .whereType<ModelProperty>()
//   //     .where((element) => element.isVisible == null || element.isEditable());

//   // Iterable<ModelProperty> get properties => widget.layoutMembers.whereType<ModelProperty>();

//   // void update(BuildContext context) {
//   //   //Sends widgets info to model
//   //   properties.where((x) => x.editable).forEach((x) {
//   //     if (x.validate(context) != null) x.update(context);
//   //   });
//   // }

//   // void undo() {
//   //   //Sends model info to widgets, reverse of update
//   //   properties.where((x) => x.editable).forEach((x) {
//   //     x.undo();
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return GetLoader<T>(
//         get: widget.get,
//         builder: (item, loading) {
//           return Form(
//             key: _formKey,
//             child: DistributionWidget(
//               <Expandable>[
//                 for (var p in visibleProperties)
//                   Expandable(
//                       widget.childPadding == null
//                           ? p.widget
//                           : Container(
//                               child: p.widget,
//                               padding: widget.childPadding,
//                             ),
//                       p.flex ?? 1)
//               ],
//               distribution: widget.distribution,
//               fixed: widget.fixed,
//               maxFlex: widget.maxFlex,
//               normalize: widget.normalize,
//             ),
//           );
//         });
//   }
// }
