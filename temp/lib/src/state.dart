import 'dart:async';

///All your stateclasses have to extend this class,
///this class does not actually have any functionality other than making it more clear which classes are state and which are not
///Good practice is keeping state immutable, try to follow this rule as much as possible.
///Example of a valid stateclass:
///```
///class Counter implements State{
///   final int count;
///   const Counter(this.counter);
///
///   Counter addOne(){
///     return Counter(counter + 1);
///   }
///}
///```
///Look at the documentation of [Store] for more details on how to implements this state
abstract class State {
  const State();
}

///Set up a listener for your state
///It is required to fill in the generic with your state,
///if you do not do this the store will be unable to find your listener.
///Example:
///```
///class Counter implements State{
///   final int count;
///   const Counter(this.counter);
///
///   Counter addOne(){
///     return Counter(counter + 1);
///   }
///}
///
///main(){
///   //sets up the Store, look at the documentation of Store for more information
///   final store = Store(const [Counter()])
///    //this prints the number of the counter everytime it changes
///   Listener<Counter>(store:store, onEvent: (state) => print(state.count))
///}
///```
///You can define these widgets anywhere inside you code, one it is called it will permanently listen to the Counter.
///To stop the listener from listening you can call [cancel]
///```
///final listener = Listener<Counter>(store:store, onEvent: (state) => print(state.count))
///listener.cancel();
///```
class Listener<T extends State> {
  final void Function(T state) onEvent;
  final Store store;

  Listener({required this.store, required this.onEvent}) {
    store.submitListener(this);
  }

  void cancel() {
    store.removeListener(this);
  }
}

///the class used to transfer the state from the store to the notifiers
///You only need to use this class if you intend to use the stores stream of state changes directly
class StatePackage<T extends State> {
  final T state;

  StatePackage(this.state);

  void forwardTolistener(Listener listener) {
    if (listener is Listener<T>) {
      (listener).onEvent(state);
    }
  }
}

///
class Store {
  final List<Listener> _userListeners = [];

  final Map<Type, State> _states;

  final StreamController<StatePackage> _streamController =
      StreamController.broadcast();

  Store(List<State> initialValues)
      : _states = {for (var v in initialValues) v.runtimeType: v} {
    _streamController.stream.listen(_onEvent);
  }

  void submitListener(Listener listener) {
    _userListeners.add(listener);
  }

  void removeListener(Listener listener) {
    _userListeners.remove(listener);
  }

  void _onEvent(StatePackage package) {
    for (final listener in _userListeners) {
      package.forwardTolistener(listener);
    }
  }

  T state<T>() {
    try {
      return _states[T] as T;
    } catch (e) {
      throw MinimalistStateError(
          "The submitted State is not known, did you supply the state to the Store?");
    }
  }

  void modifyState<T extends State>(T Function(T state) modifier) {
    try {
      _states[T] = modifier(_states[T] as T);
      _streamController.add(StatePackage<T>(_states[T] as T));
    } catch (e) {
      throw MinimalistStateError(
          "The submitted State is not known, did you supply the state to the Store?");
    }
  }

  Stream<StatePackage> get stream => _streamController.stream;
}

class MinimalistStateError extends Error {
  final String message;
  MinimalistStateError(this.message);

  @override
  String toString() {
    return 'MinimalistStateError: $message';
  }
}
