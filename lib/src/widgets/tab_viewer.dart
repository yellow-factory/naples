import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class TabItem {
  final Widget body;
  String? title;
  IconData? icon;
  int? length;
  TabCollection? tabCollection;

  TabItem({
    required this.body,
    this.title,
    this.icon,
    this.length,
    this.tabCollection,
  });

  bool get isSelected => tabCollection?.currentItem == this;
}

class TabCollection extends ChangeNotifier {
  final List<TabItem> _items = [];
  final _selectionItemOrderIndexes = <int>[];

  TabItem? get currentItem {
    if (currentIndex == null) return null;
    if (_items.isEmpty) return null;
    return _items[currentIndex!];
  }

  int? get currentIndex =>
      _selectionItemOrderIndexes.isNotEmpty ? _selectionItemOrderIndexes.last : null;
  List<TabItem> get items => UnmodifiableListView(_items);

  void notifyIndexChange(int index) {
    if (_selectionItemOrderIndexes.isEmpty || _selectionItemOrderIndexes.last != index) {
      _selectionItemOrderIndexes.add(index);
    }
  }

  void add(TabItem tab) {
    var newIndex = _items.length;
    _items.add(tab);
    notifyIndexChange(newIndex);
    tab.tabCollection = this;
    notifyListeners();
  }

  void remove(TabItem tab) {
    var indexToRemove = _items.indexOf(tab);
    if (indexToRemove == -1) {
      return; // Not found
    }

    _items.removeAt(indexToRemove);
    _selectionItemOrderIndexes.removeWhere((x) => x == indexToRemove);

    // Update the indices in _selectionItemOrderIndexes
    for (int i = 0; i < _selectionItemOrderIndexes.length; i++) {
      if (_selectionItemOrderIndexes[i] > indexToRemove) {
        _selectionItemOrderIndexes[i]--;
      }
    }

    tab.tabCollection = null;
    notifyListeners();
  }

  void removeCurrent() {
    if (currentItem == null) throw Exception('There is no current item');
    remove(currentItem!);
  }

  void changeCurrentTitle(String title) {
    if (currentItem == null) throw Exception('There is no current item');
    changeTitle(currentItem!, title);
  }

  void changeTitle(TabItem tab, String title) {
    scheduleMicrotask(() {
      var item = _items[_items.indexOf(tab)];
      if (item.title == title) return;
      item.title = title;
      notifyListeners();
    });
  }

  void changeCurrentIcon(IconData icon) {
    if (currentItem == null) throw Exception('There is no current item');
    changeIcon(currentItem!, icon);
  }

  void changeIcon(TabItem tab, IconData icon) {
    scheduleMicrotask(() {
      var item = _items[_items.indexOf(tab)];
      if (item.icon == icon) return;
      item.icon = icon;
      notifyListeners();
    });
  }

  void changeCurrentLength(int length) {
    if (currentItem == null) throw Exception('There is no current item');
    changeLength(currentItem!, length);
  }

  void changeLength(TabItem tab, int length) {
    scheduleMicrotask(() {
      var item = _items[_items.indexOf(tab)];
      if (item.length == length) return;
      item.length = length;
      notifyListeners();
    });
  }

  int get length => _items.length;
}

class _TabViewerScope extends InheritedWidget {
  const _TabViewerScope({
    super.key,
    required super.child,
    required TabViewerState tabbingViewerState,
  }) : _tabbingViewerState = tabbingViewerState;

  final TabViewerState _tabbingViewerState;

  @override
  bool updateShouldNotify(_TabViewerScope old) => false;
}

class TabViewer extends StatefulWidget {
  final FunctionOf1<Widget, Widget> builder;
  const TabViewer({
    super.key,
    required this.builder,
  });

  @override
  State<TabViewer> createState() => TabViewerState();

  static TabViewerState? of(BuildContext context) {
    final _TabViewerScope? scope = context.dependOnInheritedWidgetOfExactType<_TabViewerScope>();
    return scope?._tabbingViewerState;
  }
}

class TabViewerState extends State<TabViewer> with TickerProviderStateMixin {
  final TabCollection tabCollection = TabCollection();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    tabCollection.addListener(_changeTabController);
    _tabController = TabController(
      vsync: this,
      length: tabCollection.length,
      initialIndex: 0,
    );
    _tabController.addListener(notifyIndexChange);
  }

  void notifyIndexChange() {
    tabCollection.notifyIndexChange(_tabController.index);
  }

  void _changeTabController() {
    _tabController.removeListener(notifyIndexChange);
    _tabController = TabController(
      vsync: this,
      length: tabCollection.length,
      initialIndex: tabCollection.currentIndex ?? 0,
    );
    _tabController.addListener(notifyIndexChange);
    setState(() {});
  }

  @override
  void dispose() {
    tabCollection.removeListener(_changeTabController);
    _tabController.removeListener(notifyIndexChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _TabViewerScope(
      tabbingViewerState: this,
      child: widget.builder(
        Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 41),
              child: TabBar(
                controller: _tabController,
                tabs: tabCollection.items.map<Widget>((x) => _getTab(x)).toList(),
                labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                isScrollable: true,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: tabCollection.items.map((e) => e.body).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTab(TabItem tab) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (tab.icon != null)
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 20),
              child: tab.length == null
                  ? Icon(tab.icon)
                  : Badge.count(
                      count: tab.length!,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Icon(tab.icon),
                    ),
            ),
          Text(tab.title ?? ''),
          IconButton(
            icon: const Icon(Icons.close),
            splashRadius: 16,
            iconSize: 16,
            onPressed: () {
              tabCollection.remove(tab);
            },
          ),
        ],
      ),
    );
  }
}
