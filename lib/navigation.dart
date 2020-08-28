library yellow_naples;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model.dart';
import 'package:meta/meta.dart';
import 'dart:collection';

import 'widgets/navigation_widget.dart';

//Type of function that creates a ViewModel, needs a BuildContext
typedef ViewModel CreateViewModelFunction(BuildContext context);

class Transition<T> {
  final T beginningState;
  final T endingState;
  final bool allowBack;
  final CreateViewModelFunction _createViewModelFunction;

  Transition(this.beginningState, this.endingState, this._createViewModelFunction, this.allowBack);

  Future<StateViewModel<T>> createStateViewModel(BuildContext context) async {
    var vm = _createViewModelFunction(context);
    if (vm == null) throw new Exception("ViewModel is null");
    await vm.initialize();
    return StateViewModel<T>(endingState, vm);
  }
}

class StateViewModel<T> {
  final T state;
  final ViewModel viewModel;
  StateViewModel(this.state, this.viewModel);
}

abstract class NavigationFlow<T> {
  T _defaultState;
  CreateViewModelFunction _defaultCreateViewModelFunction;
  List<Transition<T>> _transitions = List<Transition<T>>();

  NavigationFlow(this._defaultState, this._defaultCreateViewModelFunction);

  Future<StateViewModel<T>> defaultStateViewModel(BuildContext context) async {
    final viewModel = _defaultCreateViewModelFunction(context);
    await viewModel.initialize();
    return new StateViewModel<T>(_defaultState, viewModel);
  }

  @protected
  void addTransition(T beginningState, T endingState, CreateViewModelFunction viewModelTransform,
      {bool allowBack = true}) {
    var transitionModel = Transition<T>(beginningState, endingState, viewModelTransform, allowBack);
    addTransitionModel(transitionModel);
  }

  @protected
  void addTransitionModel(Transition<T> transitionModel) {
    if (getTransitionModel(transitionModel.beginningState, transitionModel.endingState) != null)
      throw new Exception("The specified transition already exist");
    if (transitionModel.beginningState == transitionModel.endingState)
      throw new Exception("The beginningState and the endingState must be different");
    _transitions.add(transitionModel);
  }

  @protected
  Transition<T> getTransitionModel(T beginningState, T endingState) {
    return _transitions.firstWhere(
        (element) => element.beginningState == beginningState && element.endingState == endingState,
        orElse: () => null);
  }
}

//TODO: Podria ser interessant que NavigationModel disposés de la funció forward que fés la transició per defecte si només n'hi ha una, és a dir que busqués

//T és el tipus que diferencia cadascun dels estats i per tant ViewModels diferents que hi pot haver
class NavigationModel<T> extends ChangeNotifier {
  StateViewModel<T> _currentStateViewModel;
  ListQueue<StateViewModel<T>> _history = ListQueue<StateViewModel<T>>();
  final NavigationFlow<T> _navigationFlow;

  NavigationModel(this._navigationFlow);

  void initialize(StateViewModel<T> stateViewModel) {
    _updateCurrentStateViewModel(stateViewModel);
  }

  Future<void> initializeDefault(BuildContext context) async {
    initialize(await _navigationFlow.defaultStateViewModel(context));
  }

  StateViewModel<T> get currentStateViewModel => _currentStateViewModel;

  Future<bool> transition(BuildContext context, T newState) async {
    if (isBack(newState)) back();

    var tm = _navigationFlow.getTransitionModel(currentStateViewModel.state, newState);

    if (currentStateViewModel != null && tm == null) return false;

    //Adds the current to the history
    if (currentStateViewModel != null && tm.allowBack) {
      _history.add(currentStateViewModel);
    }

    //Creates and initialize the ViewModel
    var newStateViewModel = await tm.createStateViewModel(context);

    _updateCurrentStateViewModel(newStateViewModel);

    return true;
  }

  void _updateCurrentStateViewModel(StateViewModel<T> stateViewModel) {
    _currentStateViewModel = stateViewModel;
    notifyListeners();
  }

  bool isBack(T newState) => _history.isNotEmpty && _history.last.state == newState;

  Future<bool> back() async {
    if (_history.isEmpty) return false;

    //Get the last item in history
    var last = _history.last;
    ViewModel lastvm = last.viewModel;

    //Refresh the ViewModel if implements Refreshable
    if (lastvm is Refreshable) {
      var rvm = lastvm as Refreshable;
      rvm.refresh(); //Can be awaited but it locks the screen
    }

    _updateCurrentStateViewModel(last);

    //Removes the last from the history
    _history.removeLast();

    return true;
  }

  Widget get widget {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationModel<T>>.value(value: this),
        ChangeNotifierProvider<NavigationModel>.value(value: this),
      ],
      builder: (context, child) {
        //NavigationModel must be initialized with the context with access to
        //the NavigationModel because when generating the initial view
        //the context must have access to the NavigationModel
        if (currentStateViewModel == null) {
          return FutureBuilder<void>(
              future: initializeDefault(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container(child: LinearProgressIndicator());
                }
                return NavigationWidget();
              });
        }
        return NavigationWidget();
      },
    );
  }
}
