import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class TabItem {
  final Widget body;
  String? title;
  IconData? icon;
  TabItem({required this.body, this.title, this.icon});
}

class TabCollection extends ChangeNotifier {
  final List<TabItem> _items = [];
  final _selectedItemIndexes = <int>[];

  TabItem? get currentItem {
    if (currentIndex == null) return null;
    if (_items.isEmpty) return null;
    return _items[currentIndex!];
  }

  int? get currentIndex => _selectedItemIndexes.isNotEmpty ? _selectedItemIndexes.last : null;
  List<TabItem> get items => UnmodifiableListView(_items);

  void notifyIndexChange(int index) {
    if (_selectedItemIndexes.last != index) {
      _selectedItemIndexes.add(index);
    }
  }

  void add(TabItem tab) {
    var newIndex = _items.length;
    _items.add(tab);
    _selectedItemIndexes.add(newIndex);
    notifyListeners();
  }

  void remove(TabItem tab) {
    var indexToRemove = _items.indexOf(tab);
    if (indexToRemove == -1) return; //Not found
    _items.removeAt(indexToRemove);
    _selectedItemIndexes.removeWhere((x) => x == indexToRemove);
    var newSelectedItemIndexes =
        _selectedItemIndexes.map((x) => x > indexToRemove ? x - 1 : x).toList();
    _selectedItemIndexes.clear();
    _selectedItemIndexes.addAll(newSelectedItemIndexes);
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

  int get length => _items.length;
}

class _TabViewerScope extends InheritedWidget {
  const _TabViewerScope({
    Key? key,
    required Widget child,
    required TabViewerState tabbingViewerState,
  })  : _tabbingViewerState = tabbingViewerState,
        super(key: key, child: child);

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
    _tabController.dispose();
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
            TabBar(
              controller: _tabController,
              tabs: tabCollection.items.map<Widget>((x) => _getTab(x)).toList(),
              labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              isScrollable: true,
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
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(tab.icon),
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
