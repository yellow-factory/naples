import 'dart:async';
import 'package:flutter/material.dart';
import 'package:navy/navy.dart';
import 'package:meta/meta.dart';
import 'dart:collection';

class Transition<T> {
  final T beginningState;
  final T endingState;
  final bool allowBack;
  final FunctionOf0<StateViewModel<T>> _createViewModelFunction;

  Transition(this.beginningState, this.endingState, this._createViewModelFunction, this.allowBack);

  Future<StateViewModel<T>> createStateViewModel() async {
    return _createViewModelFunction();
  }
}

class ViewModel extends StatefulWidget {
  @override
  _ViewModelState createState() => _ViewModelState();
}

class _ViewModelState extends State<ViewModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class StateViewModel<T> extends StatelessWidget {
  final T state;
  final FunctionOf1<BuildContext, String> title;
  final FunctionOf1<BuildContext, Widget> builder;
  StateViewModel(
    this.state,
    this.builder, {
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}

class NavigationModel<T> extends ChangeNotifier {
  final FunctionOf0<StateViewModel<T>> _defaultCreateViewModelFunction;
  final List<Transition<T>> _transitions = List<Transition<T>>();
  final ListQueue<StateViewModel<T>> _history = ListQueue<StateViewModel<T>>();
  StateViewModel<T> _currentStateViewModel;

  NavigationModel(this._defaultCreateViewModelFunction) {
    initialize();
  }

  void initialize() {
    final stateViewModel = _defaultCreateViewModelFunction();
    _updateCurrentStateViewModel(stateViewModel);
  }

  void _updateCurrentStateViewModel(StateViewModel<T> stateViewModel) {
    _currentStateViewModel = stateViewModel;
    notifyListeners();
  }

  @protected
  void addTransition(
    T beginningState,
    T endingState,
    FunctionOf0<StateViewModel<T>> viewModelTransform, {
    bool allowBack = true,
  }) {
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
    var newStateViewModel = await transition.createStateViewModel();
    _updateCurrentStateViewModel(newStateViewModel);

    return true;
  }

  bool get canGoBack => _history.isNotEmpty;

  Future<bool> back() async {
    if (!canGoBack) return false;

    //Get the last item in history
    _updateCurrentStateViewModel(_history.last);

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
}
