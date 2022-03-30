import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

abstract class TabContainerItem extends Widget {
  String get name;
  IconData? get iconData;
}

class BasicTabContainerItem extends StatelessWidget implements TabContainerItem {
  final String name;
  final IconData? iconData;
  final Widget child;
  const BasicTabContainerItem({
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

class TabContainer<T extends TabContainerItem> extends StatefulWidget {
  final List<T> items;
  final ActionOf1<T> onDelete;
  final ValueNotifier<int>? indexNotifier;
  const TabContainer({
    Key? key,
    required this.items,
    required this.onDelete,
    this.indexNotifier,
  }) : super(key: key);

  @override
  State<TabContainer<T>> createState() => TabContainerState<T>();
}

class TabContainerState<T extends TabContainerItem> extends State<TabContainer<T>>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: widget.items.length,
      initialIndex: widget.items.length == 0 ? 0 : widget.items.length - 1,
    );
    widget.indexNotifier?.value = widget.items.length == 0 ? 0 : widget.items.length - 1;
    _tabController.addListener(notifyIndexChange);
  }

  void notifyIndexChange() {
    if (widget.indexNotifier != null) {
      if (widget.indexNotifier!.value != _tabController.index) {
        widget.indexNotifier!.value = _tabController.index;
      }
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
    if (widget.items.length == 0) return SizedBox();
    var tabs = widget.items
        .map<Widget>(
          (x) => Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (x.iconData != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(x.iconData),
                  ),
                Text(x.name),
                IconButton(
                  icon: Icon(Icons.close),
                  splashRadius: 16,
                  iconSize: 16,
                  onPressed: () {
                    widget.onDelete(x);
                  },
                ),
              ],
            ),
          ),
        )
        .toList();
    var views = widget.items.map<Widget>((x) => Card(child: x)).toList();
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: tabs,
          labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
          isScrollable: true,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: views,
          ),
        ),
      ],
    );
  }

  int get index => _tabController.index;
}
