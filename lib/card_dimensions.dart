import 'package:flutter/material.dart';

class CardDimensions {
  static double calculateCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 64) / 7;
    return cardWidth;
  }

  static double calculateCardHeight(double cardWidth) {
    return cardWidth * 1.5;
  }
}