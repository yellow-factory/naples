import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naples/widgets.dart';

/// Pumps [child] inside a [Form] (whose state is exposed via [formKey]) with a
/// minimal MaterialApp so token/theme lookups resolve.
Future<void> _pump(
  WidgetTester tester,
  GlobalKey<FormState> formKey,
  Widget child,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: Padding(padding: const EdgeInsets.all(20), child: child),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('validation error renders below the box without growing it',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    // A field that is always invalid once validated.
    final fieldKey = GlobalKey();
    await _pump(
      tester,
      formKey,
      BoxedTextFormField(
        key: fieldKey,
        label: 'Name',
        initialValue: '',
        validator: (_) => 'Required',
      ),
    );

    final box = find.byType(FieldBox);
    expect(box, findsOneWidget);
    final heightBefore = tester.getSize(box).height;
    expect(find.text('Required'), findsNothing);

    // Trigger validation (what the form's Save does).
    formKey.currentState!.validate();
    await tester.pump();

    // The error message appears…
    expect(find.text('Required'), findsOneWidget);
    // …the box keeps its single-line height (it did not grow to host the
    // error), so neighbouring fields in a row stay aligned…
    expect(tester.getSize(box).height, heightBefore);
    // …and the error sits *below* the box, not inside it.
    expect(
      tester.getTopLeft(find.text('Required')).dy,
      greaterThan(tester.getBottomLeft(box).dy - 0.5),
    );
  });

  testWidgets('valid field saves its edited text through onSaved',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    String? saved;
    await _pump(
      tester,
      formKey,
      BoxedTextFormField(
        label: 'Name',
        initialValue: 'Ada',
        onSaved: (v) => saved = v,
      ),
    );

    await tester.enterText(find.byType(TextField), 'Grace');
    formKey.currentState!.save();
    expect(saved, 'Grace');
  });
}
