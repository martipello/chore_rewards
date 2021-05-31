import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseTheme extends InheritedWidget {
  const BaseTheme({
    Key? key,
    required this.appTheme,
    required Widget child,
  }) : super(key: key, child: child);

  final AppTheme appTheme;

  BaseThemeColors get colors => appTheme.colors;

  IconThemeData get iconThemeData => appTheme.iconThemeData.iconThemeData;

  InputDecorationTheme get inputDecorationTheme => appTheme.inputDecorationTheme.inputDecorationTheme;

  Widget get logo => appTheme.logo;

  static BaseTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BaseTheme>()!;
  }

  @override
  bool updateShouldNotify(BaseTheme oldWidget) {
    return true;
  }
}

BaseThemeColors colors(BuildContext context) {
  return BaseTheme.of(context).colors;
}

class AppTheme {
  AppTheme({
    this.inputDecorationTheme = const BaseInputDecorationTheme(),
    this.colors = const BaseThemeColors(),
    this.iconThemeData = const BaseIconThemeData(),
    required this.logo,
  });

  final BaseThemeColors colors;

  final BaseInputDecorationTheme inputDecorationTheme;

  final BaseIconThemeData iconThemeData;

  final Widget logo;
}

class BaseInputDecorationTheme {
  const BaseInputDecorationTheme({
    this.inputDecorationTheme = const InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF006CC7)),
      ),
    ),
  });

  final InputDecorationTheme inputDecorationTheme;
}

class BaseIconThemeData {
  const BaseIconThemeData({
    this.iconThemeData = const IconThemeData(
      color: Color(0xFF2e2e2e),
    ),
  });

  final IconThemeData iconThemeData;
}

class BaseThemeColors {
  const BaseThemeColors({
    this.primary = const Color(0xFF006CC7),
    this.primaryLight = const Color(0xFF5b9afb),
    this.primaryDark = const Color(0xFF004296),
    this.secondary = const Color(0xFF003399),
    this.secondaryLight = const Color(0xFF505ccb),
    this.secondaryDark = const Color(0xFF00106a),
    this.foreground = const Color(0xFFFFFFFF),
    this.text = const Color(0xFF2e2e2e),
    this.textOnPrimary = const Color(0xFFFFFFFF),
    this.textOnSecondary = const Color(0xFFFFFFFF),
    this.textOnForeground = const Color(0xFF2e2e2e),
    this.chrome = const Color(0xFFCCCCCC),
    this.chromeLight = const Color(0xFFE1E1E1),
    this.chromeLighter = const Color(0xFFF2F2F4),
    this.chromeDark = const Color(0xFF333333),
    this.link = const Color(0xFF3965FF),
    this.positive = const Color(0xFF26A626),
    this.error = const Color(0xFFBA2F00),
    this.warning = const Color(0xFFFD9726),
    this.guide = const Color(0xFF80CDD8),
    this.black = const Color(0xFF000000),
    this.white = const Color(0xFFFFFFFF),
    this.background = const Color(0xFFEEEEEE),
  });

  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;
  final Color foreground;

  final Color chrome;
  final Color chromeLight;
  final Color chromeLighter;
  final Color chromeDark;
  final Color text;
  final Color textOnForeground;
  final Color textOnPrimary;
  final Color textOnSecondary;

  final Color link;

  final Color positive;
  final Color error;
  final Color warning;
  final Color guide;

  final Color black;
  final Color white;
  final Color background;
}
