// card_placeholder.dart

import 'package:flutter/material.dart';
import 'card_dimensions.dart';
import 'styles.dart';

class CardPlaceholder extends StatelessWidget {
  const CardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidth = CardDimensions.calculateCardWidth(context);
    final cardHeight = CardDimensions.calculateCardHeight(cardWidth);

    return Opacity(
      opacity: AppStyles.cardPlaceholderOpacity, // Use opacity from AppStyles
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: AppStyles.cardFaceBackgroundColor, // Use color from AppStyles
          borderRadius: BorderRadius.circular(
              AppStyles.cardBorderRadius), // Use borderRadius from AppStyles
        ),
      ),
    );
  }
}
