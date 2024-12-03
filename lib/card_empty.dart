import 'package:flutter/material.dart';
import 'package:minimalist_solitaire/card_column.dart';
import 'package:minimalist_solitaire/card_playing.dart';
import 'package:minimalist_solitaire/card_transformed.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'card_dimensions.dart';

// The deck of cards which accept the final cards (Ace to King)
class EmptyCardDeck extends StatefulWidget {
  final CardSuit cardSuit;
  final List<PlayingCard> cardsAdded;
  final CardAcceptCallback onCardAdded;
  final int columnIndex;

  const EmptyCardDeck({super.key,
    required this.cardSuit,
    required this.cardsAdded,
    required this.onCardAdded,
    required this.columnIndex,
  });

  @override
  _EmptyCardDeckState createState() => _EmptyCardDeckState();
}

class _EmptyCardDeckState extends State<EmptyCardDeck> {
  @override
  Widget build(BuildContext context) {
    final cardWidth = CardDimensions.calculateCardWidth(context); // Calculate width
    final cardHeight = CardDimensions.calculateCardHeight(cardWidth); // Calculate height

    return DragTarget<Map>(
      builder: (context, listOne, listTwo) {
        return widget.cardsAdded.isEmpty
            ? Opacity(
          opacity: 0.7,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            height: cardHeight,
            width: cardWidth,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: 20.0,
                      child: _suitToImage(),
                    ),
                  )
                ],
              ),
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
        widget.onCardAdded(
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