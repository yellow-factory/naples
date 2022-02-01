import 'package:flutter/widgets.dart';

//To send a Notification up to the tree to indicate a Refresh is needed
class NeedRefreshNotification extends Notification {}

//Inherited widget to hold the state of needed refresh or not
class Refresh extends InheritedWidget {
  const Refresh({
    Key? key,
    required this.refreshNeeded,
    required Widget child,
  }) : super(key: key, child: child);

  final NeedRefresh refreshNeeded;

  static Refresh of(BuildContext context) {
    final Refresh? result = context.dependOnInheritedWidgetOfExactType<Refresh>();
    assert(result != null, 'Refresh not found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Refresh old) => refreshNeeded.value != old.refreshNeeded.value;
}

//A class to hold the need of a refresh
class NeedRefresh extends ValueNotifier<bool> {
  NeedRefresh(bool value) : super(value);
}
