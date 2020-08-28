import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './utils.dart';
import './widgets/create_widget.dart';
import './widgets/list_widget.dart';
import './widgets/update_widget.dart';

//TODO: Les ViewModels CreateViewModel, UpdateViewModel i ListViewModel potser
//són massa específiques i potser s'haurien de posar a banda...

abstract class OneTimeInitializable {
  bool _initialized = false;

  @protected
  Future<void> init();

  Future<void> initialize() async {
    if (_initialized) return;
    await init();
    _initialized = true;
  }
}

abstract class Refreshable {
  Future<void> refresh();
}

class TitleModel extends ValueNotifier<String> {
  TitleModel(String value) : super(value);
}

class UidParam extends ValueNotifier<String> {
  UidParam(String value) : super(value);
}

abstract class ViewModel extends ChangeNotifier with OneTimeInitializable {
  BuildContext context;

  ViewModel(this.context);

  T getProvided<T>() => Provider.of<T>(context, listen: false);

  String get title;

  /// El NavigationWidget enregistra un provider de tipus ViewModel que el
  /// widget que es retorni aquí pot recuperar. Tot i així si es vol utilitzar
  /// una subclasse de ViewModel, serà necessària enregistrar-la i passar-la de
  /// nou amb el widget.
  Widget get widget;
}

abstract class GetSetViewModel<T> extends ViewModel {
  final _properties = List<EditableViewModelProperty>();
  T model;

  GetSetViewModel(BuildContext c) : super(c);

  Iterable<EditableViewModelProperty> get properties => _properties;

  void _add(EditableViewModelProperty property) {
    _properties.add(property);
    notifyListeners();
  }

  @override
  Future<void> init() async {
    model = await get();
    addProperties();
  }

  void addProperties() {
    _properties.clear();
  }

  Future<T> get();
  Future<void> set();

  void addStringProperty(String label, GetProperty<T, String> getProperty,
      {String hint,
      bool autofocus = false,
      SetProperty<T, String> setProperty,
      Predicate<T> isRequired,
      Predicate<T> isEditable,
      IsValid<String> isValid}) {
    _add(StringViewModelProperty<T>(label, model, getProperty,
        hint: hint,
        autofocus: autofocus,
        setProperty: setProperty,
        isRequired: isRequired,
        isEditable: isEditable,
        isValid: isValid));
  }

  void addIntProperty(String label, GetProperty<T, int> getProperty,
      {String hint,
      bool autofocus = false,
      SetProperty<T, int> setProperty,
      Predicate<T> isRequired,
      Predicate<T> isEditable,
      IsValid<int> isValid}) {
    _add(IntViewModelProperty<T>(label, model, getProperty,
        hint: hint,
        autofocus: autofocus,
        setProperty: setProperty,
        isRequired: isRequired,
        isEditable: isEditable,
        isValid: isValid));
  }

  void addBoolProperty(String label, GetProperty<T, bool> getProperty,
      {String hint,
      bool autofocus = false,
      SetProperty<T, bool> setProperty,
      Predicate<T> isRequired,
      Predicate<T> isEditable,
      IsValid<bool> isValid}) {
    _add(BoolViewModelProperty<T>(label, model, getProperty,
        hint: hint,
        autofocus: autofocus,
        setProperty: setProperty,
        isRequired: isRequired,
        isEditable: isEditable,
        isValid: isValid));
  }

  bool get valid {
    return properties.every((x) => x.valid);
  }

  void update() {
    properties.where((x) => x.editable).forEach((x) {
      x.update();
    });
  }

  void undo() {
    properties.where((x) => x.editable).forEach((x) {
      x.undo();
    });
  }
}

abstract class UpdateViewModel<T> extends GetSetViewModel<T> {
  UpdateViewModel(BuildContext c) : super(c);

  @override
  Widget get widget {
    return ChangeNotifierProvider<GetSetViewModel>.value(value: this, child: UpdateWidget());
  }
}

abstract class CreateViewModel<T> extends GetSetViewModel<T> {
  CreateViewModel(BuildContext c) : super(c);

  @override
  Widget get widget {
    return ChangeNotifierProvider<GetSetViewModel>.value(value: this, child: CreateWidget());
  }
}

//TODO: SearchableViewModel<T, U>

typedef U GetProperty<T, U>(T t);

abstract class ViewModelProperty<T, U> {
  final String label;
  final String hint;
  final T source;
  final GetProperty<T, U> getProperty;

  ViewModelProperty(this.label, this.source, this.getProperty, {this.hint});

  Widget get widget;
}

typedef void SetProperty<T, U>(T t, U u);
typedef String IsValid<U>(U u);

abstract class EditableViewModelProperty<T, U> extends ViewModelProperty<T, U> {
  //Pel que fa al control TextEditingController, té dues propietats: enabled i readonly,
  //que semblaria que fan coses similars i antagoniques però no es comporten del tot igual
  //Mentre enabled=false no permet el focus al control readonly=true sí que ho permet
  //Tant enabled=false com readonly=true bloquegen l'escriptura en general, però amb readonly=true
  //algunes coses com copiar, retallar o suprimir cap a la dreta estan permeses en aquesta versió (potser és un bug)
  //En el nostre cas crec que no cal fer la distinció, per això tractarem simplement la propietat editable
  //Pel que fa al control farem servir normalment enabled i no farem servir readonly

  //Es podria fer servir el onSave per realitzar el setProperty, però no estic segur si és la millor opció
  //https://forum.freecodecamp.org/t/how-to-validate-forms-and-user-input-the-easy-way-using-flutter/190377

  final bool autofocus;
  final SetProperty<T, U> setProperty;
  final Predicate<T> isRequired;
  final Predicate<T> isEditable;
  final IsValid<U> isValid;

  EditableViewModelProperty(String label, T source, GetProperty<T, U> getProperty,
      {String hint,
      this.autofocus = false,
      this.setProperty,
      this.isEditable,
      this.isRequired,
      this.isValid})
      : super(label, source, getProperty, hint: hint) {
    initialize();
  }

  void initialize();

  bool get editable => isEditable != null ? isEditable(source) : this.setProperty != null;

  bool get required => isRequired != null ? isRequired(source) : false;

  bool isEmpty(U value) => value == null;

  String validate(U value) {
    String result = '';
    if (required && isEmpty(value)) result += 'Please enter some text';
    if (isValid != null) {
      var valid = isValid(value);
      if (valid != null) result += valid;
    }
    if (result.isEmpty) return null;
    return result;
  }

  U get currentValue;
  bool get valid => validate(currentValue) == null;
  void update() {
    if (this.setProperty == null) throw Exception("setProperty not set");
    this.setProperty(source, currentValue);
  }

  void undo() {
    initialize();
  }
}

class StringViewModelProperty<T> extends EditableViewModelProperty<T, String> {
  final _controller = TextEditingController();

  StringViewModelProperty(String label, T source, GetProperty<T, String> getProperty,
      {String hint,
      bool autofocus,
      SetProperty<T, String> setProperty,
      Predicate<T> isEditable,
      Predicate<T> isRequired,
      IsValid<String> isValid})
      : super(label, source, getProperty,
            hint: hint,
            autofocus: autofocus,
            setProperty: setProperty,
            isEditable: isEditable,
            isRequired: isRequired,
            isValid: isValid);

  @override
  void initialize() {
    _controller.text = getProperty(source);
  }

  @override
  String get currentValue => _controller.text;

  @override
  bool isEmpty(String value) => value == null || value.isEmpty;

  Widget get widget {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
      ),
      enabled: editable,
      autofocus: autofocus,
      validator: validate,
    );
  }
}

class IntViewModelProperty<T> extends EditableViewModelProperty<T, int> {
  final _controller = TextEditingController();

  IntViewModelProperty(String label, T source, GetProperty<T, int> getProperty,
      {String hint,
      bool autofocus,
      SetProperty<T, int> setProperty,
      Predicate<T> isEditable,
      Predicate<T> isRequired,
      IsValid<int> isValid})
      : super(label, source, getProperty,
            hint: hint,
            autofocus: autofocus,
            setProperty: setProperty,
            isEditable: isEditable,
            isRequired: isRequired,
            isValid: isValid);

  @override
  void initialize() {
    var value = this.getProperty(source) ?? 0;
    _controller.text = value.toString();
  }

  @override
  int get currentValue {
    if (_controller.text == null) return 0;
    if (_controller.text.isEmpty) return 0;
    return int.parse(_controller.text);
  }

  @override
  bool isEmpty(int value) => value == null || value == 0;

  @override
  Widget get widget {
    return TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
        ),
        enabled: editable,
        autofocus: autofocus,
        validator: (_) {
          return validate(currentValue);
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly]);
  }
}

enum BoolWidget { Switch, CheckboxRight, CheckboxLeft }

class BoolViewModelProperty<T> extends EditableViewModelProperty<T, bool> {
  final BoolWidget boolWidget;

  BoolViewModelProperty(String label, T source, GetProperty<T, bool> getProperty,
      {String hint,
      bool autofocus,
      SetProperty<T, bool> setProperty,
      Predicate<T> isEditable,
      Predicate<T> isRequired,
      IsValid<bool> isValid,
      this.boolWidget = BoolWidget.CheckboxRight})
      : super(label, source, getProperty,
            hint: hint,
            autofocus: autofocus,
            setProperty: setProperty,
            isEditable: isEditable,
            isRequired: isRequired,
            isValid: isValid);

  @override
  void initialize() {}

  @override
  bool get currentValue {
    return this.getProperty(source) ?? false;
  }

  @override
  bool isEmpty(bool value) => value == null;

  @override
  Widget get widget {
    switch (boolWidget) {
      case BoolWidget.Switch:
        return SwitchListTile(
          title: Text(label),
          value: currentValue,
          onChanged: editable
              ? (value) {
                  this.setProperty(source, value);
                }
              : null,
          autofocus: autofocus,
          // activeTrackColor: Colors.lightGreenAccent,
          // activeColor: Colors.green,
        );
      case BoolWidget.CheckboxLeft:
        return Row(children: [
          Checkbox(
              value: currentValue,
              onChanged: editable
                  ? (value) {
                      this.setProperty(source, value);
                    }
                  : null,
              autofocus: autofocus),
          Text(label),
        ]);
      default:
        return CheckboxListTile(
            title: Text(label),
            value: currentValue,
            onChanged: editable
                ? (value) {
                    this.setProperty(source, value);
                  }
                : null,
            autofocus: autofocus,
            contentPadding: EdgeInsets.zero);
    }
  }
}

//TODO: Falten la resta de tipus: "double", "DateTime", etc.
//       case "double":
//         //En el cas de double i DateTime hauré de fer servir:
//         //https://pub.dev/documentation/intl/latest/intl/NumberFormat-class.html
//         //https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
//         //https://pub.dev/packages/intl
//         break;
//       //En el cas del DateTime, es pot mostrar el tostring en text en el locale que toqui
//       //i un botó per tal que pugui fer el showDateTimePicker i es pugui canviar...

//TODO: Cal implementar el combo i el lookup, em podria guiar per la implementació ja existent a IAS-Docència

//T tipus de dades de la llista
abstract class ListViewModel<T> extends ViewModel with Refreshable {
  List<T> _items = List<T>();
  bool _filtered = false;
  String _filterValue = "";
  T _selectedItem;
  bool loading = false;

  ListViewModel(BuildContext c) : super(c);

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
  Future<void> init() async {
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

//Reflexions: no sé si hauria d'existir una jerarquia de classes on cada element construís el seu propi widget a partir
//de les propietats de la ViewModel enlloc de fer-ho al contenidor. Això voldria dir però que hi hauria d'haver una classe per cada representació/widget que es volgués obtenir, i potser estaria
//massa lligada la viewmodel a la seva representació. També hi podria haver una classe ViewModelWidget que a partir d'una ViewModel podria crear un Widget. Aquesta seria la més assenyada?
//Això voldria dir que igualment hi hauria d'haver una conversió del tipus al widget en algun lloc.
