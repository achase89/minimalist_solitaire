// card_empty.dart

import 'package:flutter/material.dart';
import 'package:minimalist_solitaire/card_column.dart';
import 'package:minimalist_solitaire/card_playing.dart';
import 'package:minimalist_solitaire/card_transformed.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'card_dimensions.dart';
import 'styles.dart';

// foundation piles to accept cards (A to K)
class FoundationPile extends StatefulWidget {
  final CardSuit cardSuit;
  final List<PlayingCard> cardsAdded;
  final CardAcceptCallback onCardAddedToFoundation;
  final int columnIndex;

  const FoundationPile({
    super.key,
    required this.cardSuit,
    required this.cardsAdded,
    required this.onCardAddedToFoundation,
    required this.columnIndex,
  });

  @override
  FoundationPileState createState() => FoundationPileState();
}

class FoundationPileState extends State<FoundationPile> {
  @override
  Widget build(BuildContext context) {
    final cardWidth =
        CardDimensions.calculateCardWidth(context); // Calculate width
    final cardHeight =
        CardDimensions.calculateCardHeight(cardWidth); // Calculate height

    return DragTarget<Map>(
      builder: (context, listOne, listTwo) {
        return widget.cardsAdded.isEmpty
            ? Opacity(
                opacity: AppStyles
                    .cardPlaceholderOpacity, // Use opacity from AppStyles
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppStyles
                        .cardBorderRadius), // Use borderRadius from AppStyles
                    color: AppStyles
                        .cardFaceBackgroundColor, // Use color from AppStyles
                  ),
                  height: cardHeight,
                  width: cardWidth,
                  child: Center(
                    child: _suitToImage(),
                  ),
                ),
              )
            : TransformedCard(
                playingCard: widget.cardsAdded.last,
                columnIndex: widget.columnIndex,
                attachedCards: [
                  widget.cardsAdded.last,
                ],
              );
      },
      onWillAcceptWithDetails: (value) {
        PlayingCard cardAdded = value.data["cards"].last;

        if (cardAdded.cardSuit == widget.cardSuit) {
          if (CardRank.values.indexOf(cardAdded.cardRank) ==
              widget.cardsAdded.length) {
            return true;
          }
        }

        return false;
      },
      onAcceptWithDetails: (value) {
        widget.onCardAddedToFoundation(
          value.data["cards"],
          value.data["fromIndex"],
        );
      },
    );
  }

  SvgPicture? _suitToImage() {
    switch (widget.cardSuit) {
      case CardSuit.hearts:
        return SvgPicture.asset('assets/images/suit_hearts.svg');
      case CardSuit.diamonds:
        return SvgPicture.asset('assets/images/suit_diamonds.svg');
      case CardSuit.clubs:
        return SvgPicture.asset('assets/images/suit_clubs.svg');
      case CardSuit.spades:
        return SvgPicture.asset('assets/images/suit_spades.svg');
      default:
        return null;
    }
  }
}
