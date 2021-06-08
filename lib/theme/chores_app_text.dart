import 'package:flutter/widgets.dart';

extension TextStyleExtension on TextStyle {
  double get lineHeight => fontSize! * height!;

  TextStyle operator +(Color color) {
    return copyWith(color: color);
  }
}

class ChoresAppText {
  ChoresAppText._();

  // Subtitle

  static final subtitle1Style = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static final subtitle2Style = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.2,
  );

  static final subtitle3Style = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.625,
  );

  static final subtitle4Style = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    height: 1.375,
  );

  // Body

  static final body1Style = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.625,
  );

  static final body2Style = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.625,
  );

  static final body3Style = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.375,
  );

  static final body4Style = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.375,
  );

  static final body5Style = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    height: 1.375,
  );

  // Caption

  static final captionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.375,
  );

  // Header

  static final h1Style = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.normal,
    height: 4.125,
  );

  static final h2Style = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.normal,
    height: 3.188,
  );

  static final h3Style = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 2.375,
  );

  static final h4Style = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    height: 1.2,
  );

  static final h5Style = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    height: 1.2,
  );

  static final h6Style = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  // Button

  static final button1Style = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.875,
  );

  static final button2Style = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.625,
  );
}
