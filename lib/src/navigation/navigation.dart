import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naples/models.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/view_models/view_model.dart';
import 'package:meta/meta.dart';
import 'dart:collection';
import 'package:naples/widgets/navigation_widget.dart';

class Transition<T> {
  final T beginningState;
  final T endingState;
  final bool allowBack;
  final FunctionOf1<NavigationModel<T>, ViewModel> _createViewModelFunction;

  Transition(this.beginningState, this.endingState, this._createViewModelFunction, this.allowBack);

  Future<StateViewModel<T>> createStateViewModel(NavigationModel<T> navigationModel) async {
    var viewModel = _createViewModelFunction(navigationModel);
    if (viewModel == null) throw new Exception("ViewModel is null");
    return StateViewModel<T>(endingState, viewModel);
  }
}

class StateViewModel<T> {
  final T state;
  final ViewModel viewModel;
  StateViewModel(this.state, this.viewModel);
}

//T és el tipus que diferencia cadascun dels estats i per tant ViewModels diferents que hi pot haver
abstract class NavigationModel<T> extends ChangeNotifier
{
  final BuildContext context;
  final T _defaultState;
  final FunctionOf1<NavigationModel<T>, ViewModel> _defaultCreateViewModelFunction;
  final List<Transition<T>> _transitions = List<Transition<T>>();
  final ListQueue<StateViewModel<T>> _history = ListQueue<StateViewModel<T>>();
  StateViewModel<T> _currentStateViewModel;

  NavigationModel(this.context, this._defaultState, this._defaultCreateViewModelFunction) {
    initialize();
  }

  void initialize() {
    final viewModel = _defaultCreateViewModelFunction(this);
    if (viewModel == null) throw new Exception("ViewModel is null");
    final stateViewModel = StateViewModel<T>(_defaultState, viewModel);
    _updateCurrentStateViewModel(stateViewModel);
  }

  @protected
  void addTransition(T beginningState, T endingState,
      FunctionOf1<NavigationModel<T>, ViewModel> viewModelTransform,
      {bool allowBack = true}) {
    var transitionModel = Transition<T>(beginningState, endingState, viewModelTransform, allowBack);
    addTransitionModel(transitionModel);
  }

  @protected
  void addTransitionModel(Transition<T> transition) {
    if (getTransition(transition.beginningState, transition.endingState) != null)
      throw new Exception("The specified transition already exist");
    if (transition.beginningState == transition.endingState)
      throw new Exception("The beginningState and the endingState must be different");
    _transitions.add(transition);
  }

  @protected
  Transition<T> getTransition(T beginningState, T endingState) {
    return _transitions.firstWhere(
        (element) => element.beginningState == beginningState && element.endingState == endingState,
        orElse: () => null);
  }

  StateViewModel<T> get currentStateViewModel => _currentStateViewModel;

  Iterable<StateViewModel> get history => _history;

  Future<bool> transition(T newState) async {
    if (canGoBack && _history.last.state == newState) back();

    final t = getTransition(currentStateViewModel.state, newState);

    return _executeTransition(t);
  }

  Future<bool> _executeTransition(Transition transition) async {
    if (currentStateViewModel != null && transition == null) return false;

    //Adds the current to the history
    if (currentStateViewModel != null && transition.allowBack) {
      _history.add(currentStateViewModel);
    }

    //Creates and initialize the ViewModel
    var newStateViewModel = await transition.createStateViewModel(this);

    _updateCurrentStateViewModel(newStateViewModel);

    return true;
  }

  void _updateCurrentStateViewModel(StateViewModel<T> stateViewModel) {
    _currentStateViewModel = stateViewModel;
    notifyListeners();
  }

  bool get canGoBack => _history.isNotEmpty;

  Future<bool> back() async {
    if (!canGoBack) return false;

    //Get the last item in history
    final last = _history.last;
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

  bool get canGoForward {
    //Can go forward if exists one and only one transition to the next state
    return _transitions
            .where((element) => element.beginningState == currentStateViewModel.state)
            .length ==
        1;
  }

  Future<bool> forward() async {
    if (!canGoForward) return false;

    final t = _transitions
        .singleWhere((element) => element.beginningState == currentStateViewModel.state);

    return _executeTransition(t);
  }

  Widget get widget {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationModel<T>>.value(value: this),
        ChangeNotifierProvider<NavigationModel>.value(value: this),
      ],
      builder: (context, child) {
        return ChangeNotifierProvider(
            create: (_) => TitleModel(() => currentStateViewModel.viewModel.title),
            child: NavigationWidget());
      },
    );
  }
}
