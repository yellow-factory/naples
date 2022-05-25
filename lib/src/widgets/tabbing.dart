import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

abstract class TabbingItem extends StatelessWidget {
  const TabbingItem({Key? key}) : super(key: key);

  String get name;
  IconData? get iconData;
}

class DefaultTabbingItem extends StatelessWidget implements TabbingItem {
  @override
  final String name;
  @override
  final IconData? iconData;
  final Widget child;
  const DefaultTabbingItem({
    Key? key,
    required this.name,
    this.iconData,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class Tabbing extends StatefulWidget {
  final Widget child;
  const Tabbing({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<Tabbing> createState() => _TabbingState();
}

class _TabbingState extends State<Tabbing> {
  final _tabs = <TabbingItem>[];
  final _currentIndexNotifier = ValueNotifier<int?>(null);
  final _previousSelectedTabs = <int>[];

  @override
  void initState() {
    super.initState();
    _currentIndexNotifier.addListener(currentIndexChanged);
  }

  @override
  void dispose() {
    _currentIndexNotifier.removeListener(currentIndexChanged);
    super.dispose();
  }

  void currentIndexChanged() {
    if (_currentIndexNotifier.value == null) return;
    _previousSelectedTabs.add(_currentIndexNotifier.value!);
  }

  void addTab(TabbingItem tab) {
    setState(() {
      _tabs.add(tab);
      var newIndex = _tabs.length - 1;
      _currentIndexNotifier.value = newIndex;
    });
  }

  void removeTab(TabbingItem tab) {
    if (_previousSelectedTabs.isEmpty) return;
    var indexToRemove = _previousSelectedTabs.last;
    _previousSelectedTabs.removeWhere((x) => x == indexToRemove);
    for (int i = 0; i < _previousSelectedTabs.length; i++) {
      var current = _previousSelectedTabs[i];
      if (current > indexToRemove) _previousSelectedTabs[i] = current - 1;
    }
    int? newIndex;
    if (_previousSelectedTabs.isNotEmpty) {
      newIndex = _previousSelectedTabs.last;
    }
    setState(() {
      _currentIndexNotifier.value = newIndex;
      _tabs.remove(tab);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TabbingContainer(
      tabs: _tabs,
      indexNotifier: _currentIndexNotifier,
      addTab: addTab,
      removeTab: removeTab,
      child: widget.child,
    );
  }
}

class TabbingContainer extends InheritedWidget {
  final List<TabbingItem> tabs;
  final ValueNotifier<int?> indexNotifier;
  final ActionOf1<TabbingItem> addTab;
  final ActionOf1<TabbingItem> removeTab;

  void removeCurrentTab() {
    if (index == null) return;
    var tabToRemove = tabs[index!];
    removeTab(tabToRemove);
  }

  int get length => tabs.length;
  int? get index => indexNotifier.value;

  TabbingContainer({
    Key? key,
    required Iterable<TabbingItem> tabs,
    required this.indexNotifier,
    required this.addTab,
    required this.removeTab,
    required Widget child,
  })  : tabs = List.unmodifiable(tabs),
        super(key: key, child: child);

  static TabbingContainer of(BuildContext context) {
    final TabbingContainer? result = context.dependOnInheritedWidgetOfExactType<TabbingContainer>();
    assert(result != null, 'No TabContainer found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TabbingContainer old) {
    return true;
    //return length != old.length;
  }
}

class TabbingViewer extends StatefulWidget {
  final int length;
  final int? initialIndex;
  const TabbingViewer({
    Key? key,
    required this.length,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<TabbingViewer> createState() => _TabbingViewerState();
}

class _TabbingViewerState extends State<TabbingViewer> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TabbingContainer get _tabContainer => TabbingContainer.of(context);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: widget.length,
      initialIndex: widget.initialIndex ?? 0,
    );
    _tabController.addListener(notifyIndexChange);
  }

  void notifyIndexChange() {
    if (_tabContainer.index != _tabController.index) {
      _tabContainer.indexNotifier.value = _tabController.index;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(notifyIndexChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabContainer.tabs.isEmpty) return const SizedBox();
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: _tabContainer.tabs.map<Widget>((x) => TabbingTab(item: x)).toList(),
          labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          isScrollable: true,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabContainer.tabs,
          ),
        ),
      ],
    );
  }
}

class TabbingTab extends StatelessWidget {
  final TabbingItem item;
  const TabbingTab({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.iconData != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(item.iconData),
            ),
          Text(item.name),
          IconButton(
            icon: const Icon(Icons.close),
            splashRadius: 16,
            iconSize: 16,
            onPressed: () {
              TabbingContainer.of(context).removeTab(item);
            },
          ),
        ],
      ),
    );
  }
}
