import 'package:flutter/widgets.dart';

//To send a Notification up to the tree to indicate a Refresh is needed
class RefreshNotification extends Notification {}

//Inherited widget to hold the state of needed refresh or not
// class Refresh extends InheritedWidget {
//   final ValueNotifier<bool> refreshNeeded;

//   const Refresh({
//     Key? key,
//     required this.refreshNeeded,
//     required Widget child,
//   }) : super(key: key, child: child);

//   static Refresh of(BuildContext context) {
//     final Refresh? result = context.dependOnInheritedWidgetOfExactType<Refresh>();
//     assert(result != null, 'Refresh not found in context');
//     return result!;
//   }

//   @override
//   bool updateShouldNotify(Refresh old) => refreshNeeded.value != old.refreshNeeded.value;
// }
