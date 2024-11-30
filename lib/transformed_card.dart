import 'package:flutter/material.dart';
import 'package:minimalist_solitaire/card_column.dart';
import 'package:minimalist_solitaire/playing_card.dart';

// TransformedCard makes the card draggable and translates it according to
// position in the stack.
class TransformedCard extends StatefulWidget {
  final PlayingCard playingCard;
  final double transformDistance;
  final int transformIndex;
  final int columnIndex;
  final List<PlayingCard> attachedCards;

  const TransformedCard({
    super.key,
    required this.playingCard,
    this.transformDistance = 15.0,
    this.transformIndex = 0,
    required this.columnIndex,
    required this.attachedCards,
  });

  @override
  _TransformedCardState createState() => _TransformedCardState();
}

class _TransformedCardState extends State<TransformedCard> {
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          0.0,
          widget.transformIndex * widget.transformDistance,
          0.0,
        ),
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    return !widget.playingCard.faceUp
        ? Container(
      height: 60.0,
      width: 40.0,
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
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        height: 60.0,
        width: 40,
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _cardWidget(),
                  _cardWidget(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
              ),
            ),
          ],
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
        return "1";
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
}