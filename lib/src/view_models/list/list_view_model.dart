import 'package:flutter/widgets.dart';
import 'package:naples/src/view_models/list/widgets/dynamic_list_widget.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';
import 'package:naples/src/view_models/view_model.dart';

//TODO: Potser hi hauria d'haver una versió més general de ListViewModel a view_model.dart
//que no estigui lligada a cap widget en concret i aquí la versió més evolucionada, de la
//bàsica (idea semblant a getsetviewmodel) haurien de sortir list, table, etc.

mixin SelectController<T> {
  Future<void> select(T itemToSelect);
}

mixin CreateController {
  Future<void> create();
}

//T tipus de dades de la llista
abstract class ListViewModel<T> extends ViewModel with Refreshable {
  final List<T> _items = List<T>();
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  bool loading = false;

  ListViewModel(
    BuildContext context,
    this.getStream,
    this.itemTitle, {
    this.itemSubtitle,
  }) : super(context) {
    load();
  }

  Future<void> load() async {
    try {
      loading = true;
      await for (var m in getStream()) {
        addItem(m);
      }
    } catch (e) {
      throw e;
    } finally {
      loading = false;
    }
  }

  List<T> get items => _items;

  void addItem(T item) {
    _items.add(item);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  Future<void> refresh() async {
    clearItems();
    return load();
  }

  @override
  Widget get widget {
    return ChangeNotifierProvider<ListViewModel<T>>.value(
      value: this,
      child: DynamicListWidget<T>(),
    );
  }
}
