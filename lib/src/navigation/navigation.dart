import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:collection';

import 'package:navy/navy.dart';

//TODO: Crec que no s'està utilitzant Transition.allowBack, i segurament hauria
//de formar part de StateViewModel, i s'hauria d'aplicar al canGoBack, que ara mateix
//només mira si hi ha una transició anterior

class Transition<T> {
  final T beginningState;
  final T endingState;
  final bool allowBack;

  Transition(
    this.beginningState,
    this.endingState,
    this.allowBack,
  );
}

class NavigationModel<T> extends ChangeNotifier {
  final List<Transition<T>> _transitions = <Transition<T>>[];
  final ListQueue<T> _history = ListQueue<T>();
  T? _currentState;

  NavigationModel(this._currentState);

  void _updateCurrentStateViewModel(T state) {
    _currentState = state;
    notifyListeners();
  }

  @protected
  void addTransition(
    T beginningState,
    T endingState, {
    bool allowBack = true,
  }) {
    var transitionModel = Transition<T>(beginningState, endingState, allowBack);
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
  Transition<T>? getTransition(T beginningState, T endingState) {
    var test =
        (element) => element.beginningState == beginningState && element.endingState == endingState;
    if (_transitions.any(test)) return _transitions.firstWhere(test);
    return null;
  }

  T? get currentState => _currentState;

  Iterable<T> get history => _history;

  Future<bool> transition(T newState) async {
    if (canGoBack && _history.last == newState) back();
    return ifNotNullFunctionOf1(
      currentState,
      (T state) {
        final transition = getTransition(state, newState);
        return ifNotNullFunctionOf1(
          transition,
          (Transition<T> t) => _executeTransition(t),
          false,
        );
      },
      false,
    );
  }

  Future<bool> _executeTransition(Transition<T> transition) async {
    return ifNotNullPredicateOf1(currentState, (T state) {
      //Adds the current to the history
      if (transition.allowBack) {
        _history.add(state);
      }
      _updateCurrentStateViewModel(transition.endingState);
      return true;
    }, false);
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
    return _transitions.where((element) => element.beginningState == currentState).length == 1;
  }

  Future<bool> forward() async {
    if (!canGoForward) return false;

    final t = _transitions.singleWhere((element) => element.beginningState == currentState);

    return _executeTransition(t);
  }
}
