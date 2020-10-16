import 'package:flutter/widgets.dart';
import 'package:naples/src/view_models/list/list_view_model.dart';
import 'package:naples/src/view_models/list/widgets/filtered_widget.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

abstract class FilteredViewModel<T> extends ListViewModel<T> {
  bool _filtered = false;
  String _filterValue = "";

  FilteredViewModel(
    BuildContext context,
    FunctionOf0<Stream<T>> getStream,
    FunctionOf1<T, String> itemTitle, {
    FunctionOf1<T, String> itemSubtitle,
  }) : super(
          context,
          getStream,
          itemTitle,
          itemSubtitle: itemSubtitle,
        );

  //Hi hauria d'haver una enumeració per saber si filtre per title, subtitle o tots dos
  //Hi hauria d'haver una enumeració per saber com fer el tipus d'enumeració: StartsWith, contains...

  @override
  Future<void> refresh() async {
    clearItems();
    if (filtered)
      togleFiltered(); //Si està filtrat el traiem, perquè sinó potser no es veurà l'element nou o actualitzat
    return load();
  }

  get filtered => _filtered;
  Future<void> togleFiltered() async {
    _filtered = !_filtered;
    notifyListeners();
  }

  get filterValue => _filterValue;
  set filterValue(String value) {
    _filterValue = value;
    notifyListeners();
  }

  List<T> get _filteredItems => super.items.where(_filterPredicate).toList();

  @override
  List<T> get items => filtered ? _filteredItems : super.items;

  bool Function(T) get _filterPredicate {
    var filterBy = _filterValue.toLowerCase().trim();
    if ((!_filtered) || filterBy.isEmpty) return (x) => true;
    return (x) => itemTitle(x).toLowerCase().startsWith(filterBy);
  }

  @override
  Widget get widget {
    return MultiProvider(providers: [
      ChangeNotifierProvider<ListViewModel<T>>.value(value: this),
      ChangeNotifierProvider<FilteredViewModel<T>>.value(value: this),
      ChangeNotifierProvider<FilteredViewModel>.value(value: this),
    ], child: FilteredWidget<T>());
  }
}
