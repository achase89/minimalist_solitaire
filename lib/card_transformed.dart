import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minimalist_solitaire/card_column.dart';
import 'package:minimalist_solitaire/card_playing.dart';
import 'card_dimensions.dart';

// TransformedCard makes the card draggable and translates it according to
// position in the stack.
class TransformedCard extends StatefulWidget {
  final PlayingCard playingCard;
  final double transformDistance;
  final double facedownDistance;
  final int transformIndex;
  final int columnIndex;
  final List<PlayingCard> attachedCards;

  const TransformedCard({
    super.key,
    required this.playingCard,
    this.transformDistance = 20.0,
    this.facedownDistance = 8.0,
    this.transformIndex = 0,
    required this.columnIndex,
    required this.attachedCards,
  });

  @override
  TransformedCardState createState() => TransformedCardState();
}

class TransformedCardState extends State<TransformedCard> {
  @override
  Widget build(BuildContext context) {
    return  _buildCard();
  }

  Widget _buildCard() {
    final cardWidth = CardDimensions.calculateCardWidth(context);
    final cardHeight = CardDimensions.calculateCardHeight(cardWidth);

    return !widget.playingCard.faceUp
        ? Container(
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
    )
        : Draggable<Map>(
      feedback: CardColumn(
        cards: widget.attachedCards,
        columnIndex: 1,
        onCardsAdded: (card, position) {},
      ),
      childWhenDragging: _buildFaceUpCard(),
      data: {
        "cards": widget.attachedCards,
        "fromIndex": widget.columnIndex,
      },
      child: _buildFaceUpCard(),
    );
  }

  Widget _buildFaceUpCard() {
    if (widget.attachedCards.length > 1) {
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
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            border: Border.all(color: Colors.black),

        ),
        width: cardWidth,
        height: cardHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _cardRankToString(),
              style: TextStyle(
                fontSize: 16.0,
                color: widget.playingCard.cardColor == CardColor.red
                    ? Colors.red
                    : Colors.black,
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
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(color: Colors.black),
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
                      fontSize: 12.0,
                      color: widget.playingCard.cardColor == CardColor.red
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: SizedBox( // Add SizedBox here
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

  Widget _cardWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          _cardRankToString(),
          style: TextStyle(
            fontSize: 10.0,
            color: widget.playingCard.cardColor == CardColor.red ? Colors.red : Colors.black,
          ),
        ),
        Text(
          _cardRankToString(),
          style: TextStyle(
            fontSize: 10.0,
            color: widget.playingCard.cardColor == CardColor.red ? Colors.red : Colors.black,
          ),
        ),
      ],
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

  String _cardSuitToString(CardSuit cardSuit) {
    switch (cardSuit) {
      case CardSuit.hearts:
        return "H";
      case CardSuit.diamonds:
        return "D";
      case CardSuit.clubs:
        return "C";
      case CardSuit.spades:
        return "S";
    }
  }

  Widget _suitToImage(CardSuit cardSuit) {
    switch (cardSuit) {
      case CardSuit.hearts:
        return SvgPicture.asset(
          'assets/images/suit_hearts.svg',
          color: Colors.red, // Set color to red
        );
      case CardSuit.diamonds:
        return SvgPicture.asset(
          'assets/images/suit_diamonds.svg',
          color: Colors.red, // Set color to red
        );
      case CardSuit.clubs:
        return SvgPicture.asset(
          'assets/images/suit_clubs.svg',
          color: Colors.black, // Set color to black
        );
      case CardSuit.spades:
        return SvgPicture.asset(
          'assets/images/suit_spades.svg',
          color: Colors.black, // Set color to black
        );
      default:
        return const SizedBox.shrink();
    }
  }
}