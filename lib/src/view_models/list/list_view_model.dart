import 'package:flutter/widgets.dart';
import 'package:naples/src/view_models/list/widgets/list_widget.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';
import 'package:naples/src/view_models/view_model.dart';

//TODO: Potser hi hauria d'haver una versió més general de ListViewModel a view_model.dart
//que no estigui lligada a cap widget en concret i aquí la versió més evolucionada, de la
//bàsica (idea semblant a getsetviewmodel) haurien de sortir list, table, etc.

//T tipus de dades de la llista
abstract class ListViewModel<T> extends ViewModel with Refreshable {
  final List<T> _items = List<T>();
  //final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  //final ActionOf1<T> select;
  //final Function create;
  bool loading = false;

  ListViewModel(
    this.itemTitle, {
    //this.getStream,
    this.itemSubtitle,
    //this.select,
    //this.create,
  });

  Stream<T> getStream();
  Future<void> select(T itemToSelect);
  Future<void> create();

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

  @override
  Future<void> init1(BuildContext context) async {
    await super.init1(context);
    await load();
  }

  Future<void> refresh() async {
    clearItems();
    return load();
  }

  @override
  Widget get widget {
    return ChangeNotifierProvider<ListViewModel<T>>.value(value: this, child: ListWidget<T>());
  }
}
