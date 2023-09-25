import 'package:flutter/material.dart';

class StoreProvider extends InheritedWidget{
  final Store store;
  StoreProvider({super.key, })
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }


}
