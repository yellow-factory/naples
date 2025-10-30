import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class TabItem extends ChangeNotifier {
  final Widget body;
  String? _title;
  String? _titleBadge;
  String? _tooltip;
  IconData? _icon;
  int? _length;
  TabCollection? tabCollection;

  TabItem({
    required this.body,
    String? title,
    String? titleBadge,
    String? tooltip,
    IconData? icon,
    int? length,
    this.tabCollection,
  })  : _title = title,
        _titleBadge = titleBadge,
        _tooltip = tooltip,
        _icon = icon,
        _length = length;

  String? get title => _title;
  set title(String? value) {
    if (_title != value) {
      _title = value;
      notifyListeners();
    }
  }

  String? get titleBadge => _titleBadge;
  set titleBadge(String? value) {
    if (_titleBadge != value) {
      _titleBadge = value;
      notifyListeners();
    }
  }

  String? get tooltip => _tooltip;
  set tooltip(String? value) {
    if (_tooltip != value) {
      _tooltip = value;
      notifyListeners();
    }
  }

  IconData? get icon => _icon;
  set icon(IconData? value) {
    if (_icon != value) {
      _icon = value;
      notifyListeners();
    }
  }

  int? get length => _length;
  set length(int? value) {
    if (_length != value) {
      _length = value;
      notifyListeners();
    }
  }

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
    notifyListeners();
  }

  void add(TabItem tab) {
    var newIndex = _items.length;
    _items.add(tab);
    tab.tabCollection = this;
    notifyIndexChange(newIndex);
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
    tab.dispose(); // Clean up the TabItem ChangeNotifier
    notifyListeners();
  }

  void removeCurrent() {
    if (currentItem == null) throw Exception('There is no current item');
    remove(currentItem!);
  }

  int get length => _items.length;
}

class TabItemScope extends InheritedWidget {
  const TabItemScope({required super.child, required this.tabItem});

  final TabItem tabItem;

  @override
  bool updateShouldNotify(TabItemScope old) => old.tabItem != tabItem;

  static TabItem? of(BuildContext context) {
    final TabItemScope? scope = context.dependOnInheritedWidgetOfExactType<TabItemScope>();
    return scope?.tabItem;
  }
}

class _TabViewerScope extends InheritedWidget {
  const _TabViewerScope({required super.child, required TabViewerState tabbingViewerState})
    : _tabbingViewerState = tabbingViewerState;

  final TabViewerState _tabbingViewerState;

  @override
  bool updateShouldNotify(_TabViewerScope old) => false;
}

class TabViewer extends StatefulWidget {
  final FunctionOf1<Widget, Widget> builder;
  const TabViewer({super.key, required this.builder});

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
    _tabController = TabController(vsync: this, length: tabCollection.length, initialIndex: 0);
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
                children: tabCollection.items.map((e) {
                  return KeyedSubtree(
                    key: ObjectKey(e),
                    child: TabItemScope(
                      tabItem: e,
                      child: e.body,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getIconWidget(TabItem tab) {
    if (tab.icon == null) return null;
    var icon = Icon(tab.icon, color: Theme.of(context).colorScheme.secondary);
    // If length is not null, show a badge with the count
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 20),
      child:
          tab.length == null
              ? icon
              : Badge.count(
                count: tab.length!,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: icon,
              ),
    );
  }

  Widget _getTitleWidget(TabItem tab) {
    var title = Text(tab.title ?? '', style: const TextStyle(fontSize: 12));
    // If titleBadge is not null, show a badge with the count
    return tab.titleBadge == null
        ? title
        : Padding(
          padding: EdgeInsets.only(right: 30),
          child: Badge(
            offset: const Offset(20, -4),
            label: Text(tab.titleBadge!),
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: title,
          ),
        );
  }

  Widget _getTab(TabItem tab) {
    // Wrap in ListenableBuilder to rebuild when TabItem properties change
    return ListenableBuilder(
      listenable: tab,
      builder: (context, child) {
        return Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getIconWidget(tab) ?? SizedBox(),
              tab.tooltip != null && tab.tooltip!.isNotEmpty && !tab.isSelected
                  ? Tooltip(message: tab.tooltip!, child: _getTitleWidget(tab))
                  : _getTitleWidget(tab),
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
      },
    );
  }
}
