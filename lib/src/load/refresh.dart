import 'package:flutter/widgets.dart';

//To send a Notification up to the tree to indicate a Refresh is needed
class RefreshNeededNotification extends Notification {}

//Inherited widget to hold the state of needed refresh or not
class Refresh extends InheritedWidget {
  const Refresh({
    Key? key,
    required this.refreshNeeded,
    required Widget child,
  }) : super(key: key, child: child);

  final RefreshNeeded refreshNeeded;

  static Refresh of(BuildContext context) {
    final Refresh? result = context.dependOnInheritedWidgetOfExactType<Refresh>();
    assert(result != null, 'Refresh not found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Refresh old) => refreshNeeded.value != old.refreshNeeded.value;
}

//A class to hold the needed value of a refresh
class RefreshNeeded extends ValueNotifier<bool> {
  RefreshNeeded(bool value) : super(value);
}
