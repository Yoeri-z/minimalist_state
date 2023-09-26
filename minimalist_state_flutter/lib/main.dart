import 'package:flutter/material.dart';

import 'package:minimalist_state/minimalist_state.dart' as min;

class StoreProvider<T> extends InheritedWidget {
  final min.Store store;
  const StoreProvider({super.key, required this.store, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class StoreListener<T extends min.State> extends StatefulWidget {
  const StoreListener(
      {super.key,
      required this.store,
      required this.onChange,
      required this.child});
  final min.Store store;
  final VoidCallbackAction onChange;
  final Widget child;
  @override
  State<StoreListener> createState() => _StoreListenerState<T>();
}

class _StoreListenerState<T extends min.State> extends State<StoreListener> {
  late final listener;

  @override
  void initState() {
    super.initState();
    listener = min.Listener<T>(
        onEvent: (state) {
          widget.onChange;
          setState(() {});
        },
        store: widget.store);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
