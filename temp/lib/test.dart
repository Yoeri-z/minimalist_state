import 'package:minimalist_state/minimalist_state.dart';

class Counter extends State {
  final int counter;
  const Counter(this.counter);

  Counter addOne() {
    return Counter(counter + 1);
  }
}

final store = Store([Counter(0)]);

void main(List<String> args) {
  Listener<Counter>(
    store: store,
    onEvent: (state) => print(state.counter),
  );
  store.modifyState<Counter>((state) => state.addOne());
  Future.delayed(Duration(seconds: 2))
      .then((value) => store.modifyState<Counter>((state) => state.addOne()));
}
