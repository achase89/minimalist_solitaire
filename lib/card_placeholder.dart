// card_placeholder.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'card_piles.dart';
import 'card_dimensions.dart';
import 'card_creation.dart';
import 'card_visuals.dart';
import 'game_state.dart';
import 'styles.dart';

class CardPlaceholder extends StatefulWidget {
  final CardSuit? cardSuit;
  final List<PlayingCard> cardsAdded;
  final CardAcceptCallback? onCardAdded;
  final int columnIndex;
  final GameState gameState;

  const CardPlaceholder({
    super.key,
    this.cardSuit,
    required this.cardsAdded,
    this.onCardAdded,
    required this.columnIndex,
    required this.gameState,
  });

  @override
  CardPlaceholderState createState() => CardPlaceholderState();
}

class CardPlaceholderState extends State<CardPlaceholder> {
  @override
  Widget build(BuildContext context) {
    final cardWidth = CardDimensions.calculateCardWidth(context);
    final cardHeight = CardDimensions.calculateCardHeight(cardWidth);

    return DragTarget<Map>(
      builder: (context, listOne, listTwo) {
        return widget.cardsAdded.isEmpty
            ? Opacity(
          opacity: AppStyles.cardPlaceholderOpacity,
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Container(
              decoration: BoxDecoration(
                color: AppStyles.cardFaceBackgroundColor,
                borderRadius:
                BorderRadius.circular(AppStyles.cardBorderRadius),
              ),
              child: Center(
                child: _suitToImage(),
              ),
            ),
          ),
        )
            : _transformCard();
      },
      onWillAcceptWithDetails: (value) {
        if (widget.onCardAdded == null) {
          return false;
        }
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
        if (widget.onCardAdded != null) {
          widget.onCardAdded!(
            value.data["cards"],
            value.data["fromIndex"],
          );
        }
      },
    );
  }

  Widget _suitToImage() {
    if (widget.cardSuit != null) {
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
          return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _transformCard() {
    return TransformedCard(
      playingCard: widget.cardsAdded.last,
      columnIndex: widget.columnIndex,
      attachedCards: [widget.cardsAdded.last],
      gameState: widget.gameState,
    );
  }
}