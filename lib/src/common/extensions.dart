//Original idea from: https://medium.com/@ravi-pai/want-to-code-like-a-senior-flutter-dev-try-these-5-extensions-6097374a64fe
import 'package:flutter/material.dart';

//1.-Track execution time on future
//Example usage: await someFuture.trackTime('Loading data');
extension ExFuture<T> on Future<T> {
  Future<T> trackTime(String label) async {
    final stopwatch = Stopwatch()..start();
    final result = await this;
    stopwatch.stop();
    // ignore: avoid_print
    print('$label completed in ${stopwatch.elapsedMilliseconds} ms');
    return result;
  }
}

//2.-OnTap Wrapper for Any Widget
//Example usage Icon(Icons.info).onTap(() => print('Tapped!'))
extension ExTapExtension on Widget {
  Widget onTap(VoidCallback onTap) =>
      GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: this);
}

//3.-Iterable Extensions — Mapping With Index
//Example usage: anyList.mapIndexed((i, item) => Text('$i: $item'))
extension ExIndexedMap<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}

//4.-Quick Access to Screen Metrics
//Example usage: context.height * 0.3
extension ExScreenMetrics on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);
  double get width => mq.size.width;
  double get height => mq.size.height;
}

//5.-Quick Theme Access
// Example usage: Text(
//   'Hello, Flutter!',
//   style: context.textTheme.headlineSmall,
// )
extension Extheme on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  // more if you want
}

//6.-Effortlessly Insert Separators Between Widgets.
//Example usage:
//Row(
//  mainAxisAlignment: MainAxisAlignment.center,
//  children: [
//         ElevatedButton(onPressed: () {}, child: Text('Save')),
//         ElevatedButton(onPressed: () {}, child: Text('Cancel')),
//         ElevatedButton(onPressed: () {}, child: Text('Delete')),
//       ].separatedBy(SizedBox(width: 16)),
// ),
extension ExSeparated on List<Widget> {
  List<Widget> separatedBy(Widget separator) {
    if (length <= 1) return this;
    final result = <Widget>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) result.add(separator);
    }
    return result;
  }
}

//7.-Show or Hide Widgets Without the Nesting Nightmare
//Example usage: Text('Hello').withVisibility(isVisible)
extension ExVisibility on Widget {
  Widget withVisibility(bool visible) {
    return visible ? this : SizedBox.shrink();
  }
}

//8.-SnackBars Made Simple: No More Boilerplate
//Example usage:
// ElevatedButton(
//   onPressed: () => context.showSnackBar('Data saved!'),
//   child: Text('Save'),
// );
extension SnackBarExtension on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}

//9.-Say Goodbye to Null Checks with a Default Backup
//Example usage: final name = user.name.orDefault('Guest');
extension ExDefaultn<T> on T? {
  T orDefault(T defaultValue) => this ?? defaultValue;
}

//10.-Add Padding to Any Widget — Your Way
//Example usage:
// Text('Hello!').paddingAll(16);
// Icon(Icons.star).paddingSymmetric(horizontal: 8, vertical: 4);
// Container().paddingOnly(left: 10, top: 20);
extension PaddingExtensions on Widget {
  Widget paddingAll(double value) => Padding(padding: EdgeInsets.all(value), child: this);

  Widget paddingSymmetric({double vertical = 0, double horizontal = 0}) => Padding(
    padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
    child: this,
  );

  Widget paddingOnly({double left = 0, double top = 0, double right = 0, double bottom = 0}) =>
      Padding(
        padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this,
      );
}
