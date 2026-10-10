import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naples/load.dart';

// ListLoader adds each streamed item in a post-frame callback. A post-frame callback alone does not ask for a frame:
// on a still screen (no animation, no pointer moving) the items waited for the next unrelated repaint, and a list
// refreshed by code — the Explorer's schema selector after picking a schema — showed empty until the mouse moved.
void main() {
  testWidgets('an item that arrives on a still screen asks for the frame that shows it', (tester) async {
    final items = StreamController<String>();
    await tester.pumpWidget(MaterialApp(
      home: ListLoader<String>(
        getStream: () => items.stream,
        builder: (list) => Text(list.join(',')),
      ),
    ));
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);

    items.add('a');
    await tester.idle();
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pump(); // runs the callback, whose setState asks for the next frame
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pump();
    expect(find.text('a'), findsOneWidget);
    await items.close();
  });
}
