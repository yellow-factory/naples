import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

class LengthWidget extends InheritedWidget {
  final ValueNotifier<int> length;

  const LengthWidget({
    Key? key,
    required Widget child,
    required this.length,
  }) : super(key: key, child: child);

  static LengthWidget of(BuildContext context) {
    var result = context.dependOnInheritedWidgetOfExactType<LengthWidget>();
    assert(result != null, 'No LengthWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(LengthWidget oldWidget) => length.value != oldWidget.length.value;
}

class LengthProvider extends StatefulWidget {
  final Widget child;

  const LengthProvider({Key? key, required this.child}) : super(key: key);

  @override
  LengthProviderState createState() => LengthProviderState();
}

class LengthProviderState extends State<LengthProvider> {
  late ValueNotifier<int> _lengthNotifier;

  @override
  void initState() {
    super.initState();
    _lengthNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _lengthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LengthWidget(
      length: _lengthNotifier,
      child: widget.child,
    );
  }
}

class LengthConsumerWidget extends StatelessWidget {
  final FunctionOf1<int, Widget> builder;
  const LengthConsumerWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LengthWidget.of(context).length,
      builder: (context, int length, child) {
        LengthNotification(length).dispatch(context);
        return builder(length);
      },
    );
  }
}

//We use a notificationto notify up the tree that the length has changed
class LengthNotification extends Notification {
  final int length;
  LengthNotification(this.length);
}
