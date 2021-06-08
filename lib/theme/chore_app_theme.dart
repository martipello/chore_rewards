import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'base_theme.dart';
import 'chores_app_text.dart';

final choresAppTheme = AppTheme(
    colors: BaseThemeColors(
      primary: Color(0xFF64b5f6),
      primaryLight: Color(0xFF9be7ff),
      primaryDark: Color(0xFF2286c3),
      secondary: Color(0xFFc0ca33),
      secondaryLight: Color(0xFFf5fd67),
      secondaryDark: Color(0xFF8c9900),
      text: Color(0xFF5e5e5e),
      textOnForeground: Color(0xFF5e5e5e),
      textOnPrimary: Color(0xFFFFFFFF),
      textOnSecondary: Color(0xFFFFFFFF),
      chrome: Color(0xFFCCCCCC),
      chromeLight: Color(0xFFE1E1E1),
      chromeLighter: Color(0xFFF2F2F4),
      chromeDark: Color(0xFF333333),
      positive: Color(0xFF8AB341),
      error: Color(0xFFFF654B),
      warning: Color(0xFFFF654B),
      guide: Color(0xFF007CF2),
      black: Color(0xFF000000),
      white: Color(0xFFFFFFFF),
      foreground: Color(0xFFEEEEEE),
      background: Color(0xFFEEEEEE),
    ),
    logo: Text('ChoreApp'),
    inputDecorationTheme: BaseInputDecorationTheme(
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: ChoresAppText.body3Style.copyWith(color: Color(0xFF5e5e5e)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF9210),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF9210),
          ),
        ),
      ),
    ),
    iconThemeData: BaseIconThemeData(
      iconThemeData: IconThemeData(
        color: Color(0xFF2e2e2e),
      ),
    ));
