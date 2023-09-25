import 'package:minimalist_state/minimalist_state.dart';
import 'package:test/test.dart';

class Counter extends State {
  final int counter;
  const Counter(this.counter);

  Counter addOne() {
    return Counter(counter + 1);
  }
}

class Counter2 extends State {
  final int counter;
  const Counter2(this.counter);

  Counter2 addOne() {
    return Counter2(counter + 1);
  }
}

void main() {
  test('Counter', () async {
    final store = Store([Counter(0)]);
    int actual = 0;
    Listener<Counter>(
        store: store, onEvent: (state) => expect(actual, state.counter));

    actual += 1;
    store.modifyState<Counter>((state) => state.addOne());
    await Future.delayed(Duration(seconds: 1));

    actual += 1;
    store.modifyState<Counter>((state) => state.addOne());
  });
  test('Multi-listener', () async {
    final store = Store([Counter(0)]);
    int actual = 0;
    Listener<Counter>(
        store: store, onEvent: (state) => expect(actual, state.counter));
    Listener<Counter>(
        store: store, onEvent: (state) => expect(actual, state.counter));
    actual += 1;
    store.modifyState<Counter>((state) => state.addOne());
    await Future.delayed(Duration(seconds: 1));

    actual += 1;
    store.modifyState<Counter>((state) => state.addOne());
  });
  test('Multi-counter', () async {
    final store = Store([Counter(0), Counter2(0)]);
    int actual1 = 0;
    int actual2 = 0;
    Listener<Counter>(
        store: store, onEvent: (state) => expect(actual1, state.counter));
    Listener<Counter2>(
        store: store, onEvent: (state) => expect(actual2, state.counter));
    actual1 += 1;
    actual2 += 1;
    store.modifyState<Counter>((state) => state.addOne());
    store.modifyState<Counter2>((state) => state.addOne());
    await Future.delayed(Duration(seconds: 1));

    actual1 += 1;
    actual2 += 1;
    store.modifyState<Counter>((state) => state.addOne());
    store.modifyState<Counter2>((state) => state.addOne());
  });
  test('cancel', () async {
    final store = Store([Counter(0)]);
    int actual = 0;
    final listener = Listener<Counter>(
        store: store, onEvent: (state) => expect(actual, state.counter));

    actual += 1;
    store.modifyState<Counter>((state) => state.addOne());
    await Future.delayed(Duration(seconds: 1));

    listener.cancel();
    store.modifyState<Counter>((state) => state.addOne());
  });
}
