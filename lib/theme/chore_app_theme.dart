import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'base_theme.dart';
import 'chores_app_text.dart';

const primary = Color(0xFF53c4cf);
const primaryLight = Color(0xFF5cd7f4);
const primaryDark = Color(0xFF007691);
const secondary = Color(0xFFFEAE17);
const secondaryLight = Color(0xFFffc34c);
const secondaryDark = Color(0xFFc66300);
const text = Color(0xFF5e5e5e);
const textOnForeground = Color(0xFF5e5e5e);
const textOnPrimary = Color(0xFFFFFFFF);
const textOnSecondary = Color(0xFFFFFFFF);

final choresAppTheme = AppTheme(
  baseColors: const BaseThemeColors(
    primary: primary,
    primaryLight: primaryLight,
    primaryDark: primaryDark,
    secondary: secondary,
    onSecondary: secondary,
    secondaryLight: secondaryLight,
    secondaryDark: secondaryDark,
    text: text,
    textOnForeground: textOnForeground,
    textOnPrimary: textOnPrimary,
    textOnSecondary: textOnSecondary,
    chrome: Color(0xFF5c5c5d),
    chromeLight: Color(0xFF727274),
    chromeLighter: Color(0xFFB5B5B5),
    chromeDark: Color(0xFF383839),
    positive: Color(0xFF8AB341),
    error: Color(0xFFFF654B),
    warning: Color(0xFFFFAA3D),
    guide: Color(0xFF007CF2),
    black: Color(0xFF000000),
    white: Color(0xFFFFFFFF),
    foreground: Color(0xFFFAFAFA),
    background: Color(0xFFEEEEEE),
    statusCompleted: Color(0xFFA6CE39),
    statusAllocation: Color(0xFFffb933),
    statusInProgress: Color(0xFF419bf9),
    statusRejected: Color(0xFFf96a58),
    statusConfirmedLinguist: Color(0xFF53c4cf),
    serviceTelephone: Color(0xFF5e5af6),
    serviceLive: Color(0xFFffb933),
    serviceVideo: Color(0xFFffb933),
    serviceFace2Face: Color(0xFF53c4cf),
    serviceTranslation: Color(0xFF419bf9),
  ),
  colorScheme: const BaseColorScheme(
    colorScheme: ColorScheme(
      primary: primary,
      primaryVariant: primaryDark,
      secondary: secondary,
      secondaryVariant: secondaryDark,
      surface: Color(0xFFEEEEEE),
      background: Color(0xFFEEEEEE),
      error: Color(0xFFFF654B),
      onPrimary: textOnPrimary,
      onSecondary: textOnForeground,
      onSurface: Color(0xFF5c5c5d),
      onBackground: Color(0xFF5c5c5d),
      onError: Color(0xFFFF654B),
      brightness: Brightness.light,
    ),
  ),
  logo: Image.asset(
    'assets/images/wordskii_icon.png',
    height: 200,
    width: 200,
  ),
  baseInputDecorationTheme: BaseInputDecorationTheme(
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: ChoresAppText.body3Style.copyWith(
        color: const Color(0xFF5e5e5e),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: secondary,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: secondary,
        ),
      ),
    ),
  ),
  baseIconThemeData: const BaseIconThemeData(
    iconThemeData: IconThemeData(
      color: textOnPrimary,
    ),
  ),
  baseAppBarTheme: BaseAppBarTheme(
    appBarTheme: AppBarTheme(
      color: primary,
      titleTextStyle: ChoresAppText.subtitle1Style.copyWith(color: textOnPrimary),
      toolbarTextStyle: ChoresAppText.subtitle1Style.copyWith(color: textOnPrimary),
      iconTheme: const IconThemeData(
        color: textOnPrimary,
      ),
      actionsIconTheme: const IconThemeData(
        color: textOnPrimary,
      ),
    ),
  ),
  baseFont: 'Poppins',
);
