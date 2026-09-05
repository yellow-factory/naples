import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naples/src/widgets/tab_viewer.dart';

void main() {
  TabItem tab(String? identity, [String? title]) =>
      TabItem(body: const SizedBox(), identity: identity, title: title ?? identity);

  test('add makes the new tab current', () {
    final tabs = TabCollection();
    final a = tabs.add(tab('a'));
    final b = tabs.add(tab('b'));
    expect(tabs.items, [a, b]);
    expect(tabs.currentItem, b);
  });

  test('adding an identity already open focuses the open tab instead', () {
    final tabs = TabCollection();
    final a = tabs.add(tab('record:1', 'first'));
    tabs.add(tab('other'));
    expect(tabs.currentItem?.title, 'other');

    final result = tabs.add(tab('record:1', 'second'));

    expect(result, same(a), reason: 'the open tab is returned');
    expect(tabs.length, 2, reason: 'no duplicate');
    expect(tabs.currentItem, same(a));
    expect(a.title, 'first', reason: 'the open tab is kept as it was');
  });

  test('tabs without identity are always added, even if they look alike', () {
    final tabs = TabCollection();
    tabs.add(tab(null, 'new'));
    tabs.add(tab(null, 'new'));
    expect(tabs.length, 2);
  });

  test('a closed identity can be opened again', () async {
    final tabs = TabCollection();
    final a = tabs.add(tab('record:1'));
    await tabs.remove(a);
    final again = tabs.add(tab('record:1'));
    expect(tabs.items, [again]);
    expect(again, isNot(same(a)));
  });

  test('select focuses a tab that is open and ignores one that is not', () {
    final tabs = TabCollection();
    final a = tabs.add(tab('a'));
    tabs.add(tab('b'));
    tabs.select(a);
    expect(tabs.currentItem, a);
    tabs.select(tab('c'));
    expect(tabs.currentItem, a);
  });
}
