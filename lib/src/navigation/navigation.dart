import 'package:flutter/material.dart';
import 'dart:collection';

//TODO: Crec que no s'està utilitzant Transition.allowBack, i segurament hauria
//de formar part de StateViewModel, i s'hauria d'aplicar al canGoBack, que ara mateix
//només mira si hi ha una transició anterior

//TODO: una descripció més acurada d'allowBack seria potser reversible? Potser no,
//perquè quan es fa una transició es comprova que tot és correcte, i el cas d'allowBack
//és més aviat tornar enrere sense validar la situació actual, és més aviat un tornar al pas anterior (que no implica desfer)

//NavigationModel està fent el paper d'una màquina d'estats... les funcions que fa:
//Transition descriu una transició d'un node a un altre del graf de la màquina d'estats, res més
//-Emmagatzema (transitions) les possibles transicions de la màquina d'estats
//-Emmagatzema (history) l'stack actual de la màquina d'estats (anteriors a currentState)
//-Identifica (currentState) el node actual de la màquina d'estats
//-Transition: apunta la nova transició... i és capaç de saber si ha de desfer la cua o no
//-Helpers: té els mètodes back/forward cangoback/cangoforward que són helpers per simplificar les transicions més naturals

//TODO: L'element que li falta és l'estat que han o poden compartir els diferents widgets implicats.
//De fet fins aquí no hem introduït widgets, per tant potser seria millor posar aquest element a banda.
//Podríem tenir un widget, que a partir de un navigationmodel<t> i d'un estat compartit, tingués un builder per construir l'element definitiu que necessitarà en cada cas...

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

//TODO: Es podria renombrar a NavigationStateMachine o NavigationConfiguration
class NavigationModel<T> extends ChangeNotifier {
  final List<Transition<T>> _transitions = <Transition<T>>[];
  final ListQueue<T> _history = ListQueue<T>();
  T _currentState;

  NavigationModel(this._currentState);

  void _updateCurrentState(T state) {
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
    if (getTransition(transition.beginningState, transition.endingState) != null) {
      throw Exception("The specified transition already exist");
    }
    if (transition.beginningState == transition.endingState) {
      throw Exception("The beginningState and the endingState must be different");
    }
    _transitions.add(transition);
  }

  @protected
  Transition<T>? getTransition(T beginningState, T endingState) {
    var test =
        (element) => element.beginningState == beginningState && element.endingState == endingState;
    if (_transitions.any(test)) return _transitions.firstWhere(test);
    return null;
  }

  T get currentState => _currentState;

  Iterable<T> get history => _history;

  bool transition(T newState) {
    final transition = getTransition(currentState, newState);
    if (transition == null) return false; //throw Exception("There isn't a viable transition");
    _executeTransition(transition);
    return true;
  }

  void _executeTransition(Transition<T> transition) {
    //Adds the current to the history
    if (transition.allowBack) {
      _history.add(currentState);
    }
    _updateCurrentState(transition.endingState);
  }

  bool get canGoBack => _history.isNotEmpty;

  bool back() {
    if (!canGoBack) return false;

    //Get the last item in history
    _updateCurrentState(_history.last);

    //Removes the last from the history
    _history.removeLast();

    return true;
  }

  bool get canGoForward {
    //Can go forward if exists one and only one transition to the next state
    return _transitions.where((element) => element.beginningState == currentState).length == 1;
  }

  bool forward() {
    if (!canGoForward) return false;

    final t = _transitions.singleWhere((element) => element.beginningState == currentState);

    _executeTransition(t);

    return true;
  }
}

// class NavigationModelWithSharedState<T, U> extends NavigationModel<T> {
//   final U _sharedState;
//   NavigationModelWithSharedState(T currentState, this._sharedState) : super(currentState);
// }

class StateMachineWidget<T, U> extends StatefulWidget {
  final T currentState; //També podria ser el NavigationModel de T que ja té el currentState

  //TODO: U seria l'estat que compartirien els diferents widgets

  //TODO: a partir d'un estat de tipus T torna un widget??
  final Map<T, T> builder;

  const StateMachineWidget(this.currentState, this.builder);

  @override
  _StateMachineWidgetState<T, U> createState() => _StateMachineWidgetState<T, U>();
}

class _StateMachineWidgetState<T, U> extends State<StateMachineWidget<T, U>> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

//TODO: Potser seria interessant tenir un altre StateMachinePageWidget que emboliqués els widgets amb un widget tipus Page quan els emetés
