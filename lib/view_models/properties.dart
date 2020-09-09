import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_naples/utils.dart';
import 'package:yellow_naples/view_models/view_model.dart';

class StringViewModelProperty<T> extends EditableViewModelProperty<T, String> {
  final _controller = TextEditingController();

  StringViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, String> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, String> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired,
      FunctionOf1<String, String> isValid})
      : super(label, source, getProperty,
            hint: hint,
            flex: flex,
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
        hintText: hint != null ? hint() : null,
        labelText: label(),
      ),
      enabled: editable,
      autofocus: autofocus,
      validator: validate,
    );
  }
}

class IntViewModelProperty<T> extends EditableViewModelProperty<T, int> {
  final _controller = TextEditingController();

  IntViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, int> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, int> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired,
      FunctionOf1<int, String> isValid})
      : super(label, source, getProperty,
            hint: hint,
            flex: flex,
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
          hintText: hint != null ? hint() : null,
          labelText: label(),
        ),
        enabled: editable,
        autofocus: autofocus,
        validator: (_) {
          return validate(currentValue);
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]);
  }
}

enum BoolWidget { Switch, CheckboxRight, CheckboxLeft }

class BoolViewModelProperty<T> extends EditableViewModelProperty<T, bool> {
  final BoolWidget boolWidget;

  BoolViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, bool> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, bool> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired,
      FunctionOf1<bool, String> isValid,
      this.boolWidget = BoolWidget.CheckboxRight})
      : super(label, source, getProperty,
            hint: hint,
            flex: flex,
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
        return _getSwitch();
      case BoolWidget.CheckboxLeft:
        return _getCheckBoxListTile(ListTileControlAffinity.leading);
      default:
        return _getCheckBoxListTile(ListTileControlAffinity.trailing);
    }
  }

  Widget _getSwitch() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return SwitchListTile(
          title: Text(
            label(),
          ),
          value: currentValue,
          onChanged: editable
              ? (value) {
                  setState(() {
                    this.setProperty(source, value);
                  });
                }
              : null,
          autofocus: autofocus,
          contentPadding: EdgeInsets.zero
          // activeTrackColor: Colors.lightGreenAccent,
          // activeColor: Colors.green,

          );
    });
  }

  Widget _getCheckBoxListTile(ListTileControlAffinity controlAffinity) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return CheckboxListTile(
          title: Text(label()),
          controlAffinity: controlAffinity,
          value: currentValue,
          onChanged: editable
              ? (value) {
                  setState(() {
                    this.setProperty(source, value);
                  });
                }
              : null,
          autofocus: autofocus,
          contentPadding: EdgeInsets.zero);
    });
  }
}

class FileViewModelProperty<T> extends EditableViewModelProperty<T, List<int>> {
  List<int> _value;

  FileViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, List<int>> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, List<int>> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired})
      : super(label, source, getProperty,
            hint: hint,
            flex: flex,
            autofocus: autofocus,
            setProperty: setProperty,
            isEditable: isEditable,
            isRequired: isRequired);

  @override
  List<int> get currentValue => _value;

  @override
  void initialize() {
    _value = getProperty(source);
  }

  @override
  Widget get widget {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            leading: Icon(Icons.attachment_outlined),
            title: Text(label()),
            subtitle: Text(hint()),
          ),
          ButtonBar(
            children: <Widget>[
              OutlineButton.icon(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  print("File deleted");
                },
                label: Text("Delete"),
              ),
              OutlineButton.icon(
                  icon: Icon(Icons.cloud_upload_outlined),
                  label: Text("Upload"),
                  onPressed: () {
                    print("File uploaded");
                  }),
              OutlineButton.icon(
                icon: Icon(Icons.cloud_download_outlined),
                label: Text("Download"),
                onPressed: () {
                  print("File downloaded");
                },
              ),
            ],
          )
        ]));
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
