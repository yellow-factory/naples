import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/view_models/view_model.dart';
import 'package:yellow_naples/navigation/navigation.dart';
import 'package:yellow_naples/widgets/list_widget.dart';
import 'package:yellow_naples/widgets/save_cancel_widget.dart';
import 'package:yellow_naples/widgets/single_step_widget.dart';
import 'package:yellow_naples/models.dart';

import '../widgets/dynamic_form_widget.dart';

mixin StepViewModelController<T> on GetSetViewModel<T> {
  NavigationModel get navigationModel => getProvided();

  bool get hasNextStep => navigationModel.canGoForward;

  Future<void> nextStep() async {
    if (!valid) return;
    update(); //Sends changes from widgets to the model
    await set(); //Sends changes from model to the backend
    await navigationModel.forward();
  }

  bool get hasPreviousStep => navigationModel.canGoBack;

  Future<void> previousStep() async {
    await navigationModel.back();
  }
}

abstract class RawStepViewModel<T> extends GetSetViewModel<T> with StepViewModelController<T> {
  @override
  Widget get widget {
    return ChangeNotifierProvider<GetSetViewModel>.value(value: this, child: DynamicFormWidget());
  }
}

abstract class SingleStepViewModel<T> extends GetSetViewModel<T> with StepViewModelController<T> {
  @override
  Widget get widget {
    return ChangeNotifierProvider<StepViewModelController>.value(
        value: this, child: SingleStepWidget());
  }
}

abstract class SaveCancelViewModel<T> extends GetSetViewModel<T> {
  NavigationModel get navigationModel => getProvided();
  SnackModel get snackModel => getProvided();

  Future<void> cancel() async {
    var back = await navigationModel.back();
    print('Invoking back, result: $back');
  }

  Future<void> save() async {
    if (!valid) return;
    update(); //Send the changes of the controls to the viewmodel
    await set(); //Send the changes to the backend
    await navigationModel.back(); //Returns to the previous view
    snackModel.message = "Saved!"; //Sends a snack message
  }

//TODO: Igual que en el cas de SingleStepWidget, hauria de ser el SaveCancelWidget el que
//exposés GetSetViewModel, i no des d'aquí, que tingui només una responsabilitat

  @override
  Widget get widget {
    return MultiProvider(providers: [
      ChangeNotifierProvider<SaveCancelViewModel>.value(value: this), //used by SaveCancelWidget
      ChangeNotifierProvider<GetSetViewModel>.value(value: this) //used by DynamicFormWidget
    ], child: SaveCancelWidget());
  }
}

//TODO: SearchableViewModel<T, U>, TableViewModel...

//TODO: Potser hi hauria d'haver una versió més general de ListViewModel a view_model.dart
//que no estigui lligada a cap widget en concret i aquí la versió més evolucionada, de la
//bàsica (idea semblant a getsetviewmodel) haurien de sortir list, table, etc.

//T tipus de dades de la llista
abstract class ListViewModel<T> extends ViewModel with Refreshable {
  List<T> _items = List<T>();
  bool _filtered = false;
  String _filterValue = "";
  T _selectedItem;
  bool loading = false;

  //Hi hauria d'haver una enumeració per saber si filtre per title, subtitle o tots dos
  //Hi hauria d'haver una enumeració per saber com fer el tipus d'enumeració: StartsWith, contains...

  Stream<T> getStream();

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
    if (filtered)
      togleFiltered(); //Si està filtrat el traiem, perquè sinó potser no es veurà l'element nou o actualitzat
    return load();
  }

  // TODO: Hauríem de diferenciar entre ListViewModel i TableViewModel, perquè el List ha de definir title i subtitle, i el table no
  // però tots dos tenen en comú el list()

  String itemTitle(T t);
  String itemSubtitle(T t);

  get filtered => _filtered;
  void togleFiltered() {
    _filtered = !_filtered;
    notifyListeners();
  }

  get filterValue => _filterValue;
  set filterValue(String value) {
    _filterValue = value;
    notifyListeners();
  }

  List<T> get _filteredItems => _items.where(_filterPredicate).toList();

  List<T> get items => filtered ? _filteredItems : _items;

  bool Function(T) get _filterPredicate {
    var filterBy = _filterValue.toLowerCase().trim();
    if ((!_filtered) || filterBy.isEmpty) return (x) => true;
    return (x) => itemTitle(x).toLowerCase().startsWith(filterBy);
  }

  T get selectedItem => _selectedItem;

  Future<void> select(T itemToSelect) async {
    _selectedItem = itemToSelect;
    notifyListeners();
  }

  //TODO: S'ha de repensar si això encara fa falta, i si cal tenir el punter al item seleccionat o no cal...
  void clearSelectedItem([bool notify = true]) {
    _selectedItem = null;
    if (notify) notifyListeners();
  }

  Future<void> create();

  @override
  Widget get widget {
    return ChangeNotifierProvider<ListViewModel>.value(value: this, child: ListWidget());
  }
}
