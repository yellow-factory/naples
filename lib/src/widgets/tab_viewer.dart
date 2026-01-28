import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class TabItem extends ChangeNotifier {
  final Widget body;
  final GlobalKey _bodyKey = GlobalKey();
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
  }) : _title = title,
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
  const TabItemScope({super.key, required super.child, required this.tabItem});

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
    if (_tabController.length == tabCollection.length) {
      if (tabCollection.currentIndex != null &&
          _tabController.index != tabCollection.currentIndex) {
        _tabController.animateTo(tabCollection.currentIndex!);
      }
      return;
    }

    _tabController.removeListener(notifyIndexChange);
    final oldController = _tabController;
    _tabController = TabController(
      vsync: this,
      length: tabCollection.length,
      initialIndex: tabCollection.currentIndex ?? 0,
    );
    _tabController.addListener(notifyIndexChange);
    // Dispose old controller and trigger rebuild after the frame to avoid layout mutation issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      oldController.dispose();
      if (mounted) setState(() {});
    });
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
                    key: e._bodyKey,
                    child: TabItemScope(tabItem: e, child: e.body),
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
      child: tab.length == null
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

  void _showTabContextMenu(BuildContext context, TabItem tab, Offset position) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final tabIndex = tabCollection.items.indexOf(tab);
    final hasItemsToRight = tabIndex != -1 && tabIndex < tabCollection.items.length - 1;
    final hasOtherItems = tabCollection.items.length > 1;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(position & const Size(1, 1), Offset.zero & overlay.size),
      items: [
        PopupMenuItem(
          height: 32,
          child: const Text('Close', style: TextStyle(fontSize: 13)),
          onTap: () {
            tabCollection.remove(tab);
          },
        ),
        PopupMenuItem(
          height: 32,
          enabled: hasOtherItems,
          onTap: hasOtherItems
              ? () {
                  final itemsToRemove = tabCollection.items.where((item) => item != tab).toList();
                  for (var item in itemsToRemove) {
                    tabCollection.remove(item);
                  }
                }
              : null,
          child: Text(
            'Close others',
            style: TextStyle(fontSize: 13, color: hasOtherItems ? null : Colors.grey),
          ),
        ),
        PopupMenuItem(
          height: 32,
          enabled: hasItemsToRight,
          onTap: hasItemsToRight
              ? () {
                  final itemsToRemove = tabCollection.items.skip(tabIndex + 1).toList();
                  for (var item in itemsToRemove) {
                    tabCollection.remove(item);
                  }
                }
              : null,
          child: Text(
            'Close to the right',
            style: TextStyle(fontSize: 13, color: hasItemsToRight ? null : Colors.grey),
          ),
        ),
        PopupMenuItem(
          height: 32,
          child: const Text('Close all', style: TextStyle(fontSize: 13)),
          onTap: () {
            final itemsToRemove = tabCollection.items.toList();
            for (var item in itemsToRemove) {
              tabCollection.remove(item);
            }
          },
        ),
      ],
    );
  }

  Widget _getTab(TabItem tab) {
    // Wrap in ListenableBuilder to rebuild when TabItem properties change
    return ListenableBuilder(
      listenable: tab,
      builder: (context, child) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onSecondaryTapDown: (details) {
              _showTabContextMenu(context, tab, details.globalPosition);
            },
            child: Tab(
              child: _TabContent(
                tab: tab,
                tabCollection: tabCollection,
                getIconWidget: _getIconWidget,
                getTitleWidget: _getTitleWidget,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabContent extends StatefulWidget {
  final TabItem tab;
  final TabCollection tabCollection;
  final Widget? Function(TabItem) getIconWidget;
  final Widget Function(TabItem) getTitleWidget;

  const _TabContent({
    required this.tab,
    required this.tabCollection,
    required this.getIconWidget,
    required this.getTitleWidget,
  });

  @override
  State<_TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<_TabContent> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.tab.isSelected;
    final showCloseButton = isSelected || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.getIconWidget(widget.tab) ?? const SizedBox(),
          widget.tab.tooltip != null && widget.tab.tooltip!.isNotEmpty && !isSelected
              ? Tooltip(message: widget.tab.tooltip!, child: widget.getTitleWidget(widget.tab))
              : widget.getTitleWidget(widget.tab),
          if (showCloseButton)
            SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, size: 16),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  minimumSize: const Size(24, 24),
                  maximumSize: const Size(24, 24),
                ),
                onPressed: () {
                  widget.tabCollection.remove(widget.tab);
                },
              ),
            )
          else
            const SizedBox(width: 24), // Reserve space for the close button
        ],
      ),
    );
  }
}
