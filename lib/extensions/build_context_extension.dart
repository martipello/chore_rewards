import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get scaleFactor => MediaQuery.of(this).textScaleFactor;

  NavigatorState get navigator => Navigator.of(this);

  MaterialLocalizations get materialLocale => MaterialLocalizations.of(this);

  dynamic get routeArguments => ModalRoute.of(this)?.settings.arguments;
}
