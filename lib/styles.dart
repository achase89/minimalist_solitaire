// styles.dart

import 'package:flutter/material.dart';

class AppStyles {
  static const Color backgroundColor = Colors.green;
  static const Color buttonActiveIconColor = Colors.white;
  static const Color buttonOnPressIconColor = Colors.green;
  static const Color buttonInactiveIconColor = Colors.white24;
  static const Color cardFaceBackgroundColor = Colors.white;
  static const Color cardBackBackgroundColor = Colors.lightGreen;
  static const Color cardBorderColor = Colors.black;
  static const Color cardSuitColorLight = Colors.red;
  static const Color cardSuitColorDark = Colors.black;
  static const double cardPlaceholderOpacity = 0.2;
  static const double cardBorderRadius = 8.0;
  static const TextStyle cardFullFaceTextStyle =
      TextStyle(fontSize: 16.0, color: Colors.black);
  static const TextStyle cardPartialFaceTextStyle =
      TextStyle(fontSize: 12.0, color: Colors.black);
  static const double cardBorderWidth = 1.0;
// ... add more styles as needed ...

  static ButtonStyle pillShapedButtonStyle({
    required Color activeColor,
    required Color inactiveColor,
    required Color onPressColor,
    required IconData icon,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return activeColor;
          }
          return Colors.transparent;
        },
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
      elevation: WidgetStateProperty.all<double>(0.0),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.all(8.0),
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return onPressColor;
          } else if (states.contains(WidgetState.disabled)) {
            return inactiveColor;
          }
          return activeColor; // Default color when enabled
        },
      ),
    );
  }
}
