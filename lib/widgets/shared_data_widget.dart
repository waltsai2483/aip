import 'package:flutter/cupertino.dart';

import '../main.dart';

class SharedDataWidget extends InheritedWidget {
  final MyAppState data;
  const SharedDataWidget(this.data, {super.key, required super.child});

  static SharedDataWidget? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}