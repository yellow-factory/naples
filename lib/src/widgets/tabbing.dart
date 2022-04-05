import 'package:flutter/material.dart';

class TabbingItem extends StatelessWidget {
  final String name;
  final IconData? iconData;
  final Widget child;
  const TabbingItem({
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
  final _currentIndexNotifier = ValueNotifier<int>(0);
  int _currentIndex = 0;
  int _previousIndex = 0;

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
    _previousIndex = _currentIndex;
    _currentIndex = _currentIndexNotifier.value;
  }

  void addTab(TabbingItem tab) {
    setState(() {
      _tabs.add(tab);
      _currentIndexNotifier.value = _tabs.length - 1;
    });
  }

  void removeTab(TabbingItem tab) {
    var currentTabIndex = _tabs.indexOf(tab);
    var newIndex = currentTabIndex == _currentIndexNotifier.value
        ? _previousIndex
        : _currentIndexNotifier.value;
    if (newIndex > 0 && newIndex >= currentTabIndex) newIndex--;
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
  final ValueNotifier<int> indexNotifier;
  final Function addTab;
  final Function removeTab;

  void removeCurrentTab() {
    var tabToRemove = tabs[currentTabIndex];
    removeTab(tabToRemove);
  }

  int get length => tabs.length;
  int get currentTabIndex => indexNotifier.value;

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
    assert(result != null, 'No TabContainerRoot found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TabbingContainer old) {
    return tabs.length != old.tabs.length;
  }
}

class TabbingViewer extends StatefulWidget {
  final int length;
  final int initialIndex;
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
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(notifyIndexChange);
  }

  void notifyIndexChange() {
    if (_tabContainer.currentTabIndex != _tabController.index) {
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
    if (_tabContainer.tabs.length == 0) return SizedBox();
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: _tabContainer.tabs.map<Widget>((x) => TabbingTab(item: x)).toList(),
          labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
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
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(item.iconData),
            ),
          Text(item.name),
          IconButton(
            icon: Icon(Icons.close),
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
