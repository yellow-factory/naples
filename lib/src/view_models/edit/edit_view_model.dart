import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/src/view_models/view_model.dart';
import 'package:naples/src/view_models/edit/properties/view_property.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';

abstract class EditViewModel<T> extends ViewModelOf<T> {
  final _layoutMembers = List<ViewProperty>();

  EditViewModel() : super();

  Iterable<ViewProperty> get layoutMembers => _layoutMembers;

  void add(ViewProperty member) {
    _layoutMembers.add(member);
    //If the member notify changes the viewModel container should also notify changes
    member.addListener(() {
      notifyListeners();
    });
  }

  void addMultiple(List<ViewProperty> members) {
    members.forEach(
      (element) {
        add(element);
      },
    );
  }

  @override
  Future<void> init1(BuildContext context) async {
    await super.init1(context);
    model = await get();
    addLayoutMembers();
  }

  @nonVirtual
  void addLayoutMembers() {
    _layoutMembers.clear();
    addingLayoutMembers();
    notifyListeners();
  }

  void addingLayoutMembers();

  Future<T> get();
  Future<void> set();

  Iterable<ViewProperty> get visibleProperties => layoutMembers
      .whereType<ViewProperty>()
      .where((element) => element.isVisible == null || element.isVisible());

  Iterable<ModelProperty> get editableProperties => layoutMembers
      .whereType<ModelProperty>()
      .where((element) => element.isVisible == null || element.isEditable());

  Iterable<ModelProperty> get properties => layoutMembers.whereType<ModelProperty>();

  bool get valid {
    return properties.every((x) => x.valid);
  }

  void update() {
    //Sends widgets info to model
    properties.where((x) => x.editable).forEach((x) {
      if (x.valid) x.update();
    });
  }

  void undo() {
    //Sends model info to widgets, reverse of update
    properties.where((x) => x.editable).forEach((x) {
      x.undo();
    });
  }
}
