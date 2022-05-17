import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

class LengthWidget extends InheritedWidget {
  final ValueNotifier<int> length;

  const LengthWidget({
    Key? key,
    required this.length,
    required Widget child,
  }) : super(key: key, child: child);

  static LengthWidget of<T>(BuildContext context) {
    var result = context.dependOnInheritedWidgetOfExactType<LengthWidget>();
    assert(result != null, 'No LengthWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(LengthWidget old) => length != old.length;
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
      builder: (context, int length, child) => builder(length),
    );
  }
}
