// card_visuals.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'card_piles.dart';
import 'card_creation.dart';
import 'card_dimensions.dart';
import 'card_movement.dart';
import 'game_state.dart';
import 'styles.dart';

class TransformedCard extends StatefulWidget {
  final PlayingCard playingCard;
  final double transformDistance;
  final double facedownDistance;
  final int transformIndex;
  final int columnIndex;
  final List<PlayingCard> attachedCards;
  final Color? backgroundColor;
  final GameState gameState;
  const TransformedCard({
    super.key,
    required this.playingCard,
    this.transformDistance = 20.0,
    this.facedownDistance = 8.0,
    this.transformIndex = 0,
    required this.columnIndex,
    required this.attachedCards,
    required this.gameState,
    this.backgroundColor,
  });
  @override
  TransformedCardState createState() => TransformedCardState();
}

class TransformedCardState extends State<TransformedCard> {
  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Widget _buildCard() {
    final cardWidth = CardDimensions.calculateCardWidth(context);
    final cardHeight = CardDimensions.calculateCardHeight(cardWidth);
    return !widget.playingCard.faceUp
        ? Container(
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        color:
        widget.backgroundColor ?? AppStyles.cardBackBackgroundColor,
        border: Border.all(
          color: AppStyles.cardBorderColor,
          width: AppStyles.cardBorderWidth,
        ),
        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
      ),
    )
        : _buildDraggableCard();
  }

  Widget _buildDraggableCard() {
    // Determine feedback based on originPile
    Widget feedbackWidget;
    feedbackWidget = SizedBox(
      width: CardDimensions.calculateCardWidth(context),
      child: CardColumn(
        cards: widget.attachedCards,
        columnIndex: widget.columnIndex,
        onCardsAddedToColumn: (cards, fromIndex) {
          CardMovement.moveToColumn(fromIndex, widget.columnIndex, cards, widget.gameState); // Assuming gameState is accessible here
        },
        gameState: widget.gameState,
      ),
    );

    // Determine childWhenDragging based on originPile
    Widget childWhenDraggingWidget;

    // Directly show the card below
    childWhenDraggingWidget = _buildCardBelow();

    return Draggable<Map>(
      feedback: feedbackWidget,
      childWhenDragging: childWhenDraggingWidget,
      data: {
        "cards": widget.attachedCards,
        "fromIndex": widget.columnIndex,
      },
      child: _buildFaceUpCardVisual(),
    );
  }

  Widget _buildFaceUpCardVisual() {
    if (widget.attachedCards.length > 1) { // Modify this line
      return _buildFaceUpCardPartial(); // Use partial style
    } else {
      return _buildFaceUpCardFull(); // Use full style
    }
  }

  Widget _buildFaceUpCardFull() {
    final cardWidth = CardDimensions.calculateCardWidth(context);
    final cardHeight = CardDimensions.calculateCardHeight(cardWidth);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppStyles.cardFaceBackgroundColor,
          border: Border.all(
            color: AppStyles.cardBorderColor,
            width: AppStyles.cardBorderWidth,
          ),
          borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
        ),
        width: cardWidth,
        height: cardHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _cardRankToString(),
              style: TextStyle(
                fontSize: AppStyles.cardFullFaceTextStyle
                    .fontSize, // Use fontSize from cardFullFaceTextStyle
                color: widget.playingCard.cardColor ==
                    CardColor.red // Keep the conditional color logic
                    ? AppStyles
                    .cardSuitColorLight // Use cardSuitColorLight from AppStyles
                    : AppStyles
                    .cardSuitColorDark, // Use cardSuitColorDark from AppStyles
              ),
            ),
            _suitToImage(widget.playingCard.cardSuit),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceUpCardPartial() {
    final cardWidth = CardDimensions.calculateCardWidth(context);
    final cardHeight = CardDimensions.calculateCardHeight(cardWidth);
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppStyles.cardFaceBackgroundColor,
          border: Border.all(
            color: AppStyles.cardBorderColor,
            width: AppStyles.cardBorderWidth,
          ),
          borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
        ),
        width: cardWidth,
        height: cardHeight,
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _cardRankToString(),
                    style: TextStyle(
                      fontSize: AppStyles.cardPartialFaceTextStyle
                          .fontSize, // Use fontSize from cardPartialFaceTextStyle
                      color: widget.playingCard.cardColor ==
                          CardColor.red // Keep the conditional color logic
                          ? AppStyles
                          .cardSuitColorLight // Use cardSuitColorLight from AppStyles
                          : AppStyles
                          .cardSuitColorDark, // Use cardSuitColorDark from AppStyles
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: SizedBox(
                      // Add SizedBox here
                      width: 16, // Adjust width as needed
                      height: 16, // Adjust height as needed
                      child: _suitToImage(widget.playingCard.cardSuit),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _cardRankToString() {
    switch (widget.playingCard.cardRank) {
      case CardRank.one:
        return "A";
      case CardRank.two:
        return "2";
      case CardRank.three:
        return "3";
      case CardRank.four:
        return "4";
      case CardRank.five:
        return "5";
      case CardRank.six:
        return "6";
      case CardRank.seven:
        return "7";
      case CardRank.eight:
        return "8";
      case CardRank.nine:
        return "9";
      case CardRank.ten:
        return "10";
      case CardRank.jack:
        return "J";
      case CardRank.queen:
        return "Q";
      case CardRank.king:
        return "K";
      default:
        return "";
    }
  }

  Widget _suitToImage(CardSuit cardSuit) {
    switch (cardSuit) {
      case CardSuit.hearts:
        return SvgPicture.asset(
          'assets/images/suit_hearts.svg',
          color: AppStyles.cardSuitColorLight,
        );
      case CardSuit.diamonds:
        return SvgPicture.asset(
          'assets/images/suit_diamonds.svg',
          color: AppStyles.cardSuitColorLight,
        );
      case CardSuit.clubs:
        return SvgPicture.asset(
          'assets/images/suit_clubs.svg',
          color: AppStyles.cardSuitColorDark,
        );
      case CardSuit.spades:
        return SvgPicture.asset(
          'assets/images/suit_spades.svg',
          color: AppStyles.cardSuitColorDark,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // Helper method to build the feedback for waste/foundation piles
  Widget _buildCardBelow() {
    if (widget.transformIndex > 0 &&
        widget.attachedCards.isNotEmpty &&
        widget.transformIndex - 1 < widget.attachedCards.length) {
      return TransformedCard(
        playingCard: widget.attachedCards[widget.transformIndex - 1],
        columnIndex: widget.columnIndex,
        attachedCards: [widget.attachedCards[widget.transformIndex - 1]],
        transformIndex: widget.transformIndex - 1,
        gameState: widget.gameState,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}