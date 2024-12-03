import 'package:flutter/material.dart';
import 'package:minimalist_solitaire/card_playing.dart';
import 'package:minimalist_solitaire/card_transformed.dart';
import 'card_dimensions.dart';

typedef CardAcceptCallback = Null Function(List<PlayingCard> card, int fromIndex);

// This is a stack of overlayed cards (implemented using a stack)
class CardColumn extends StatefulWidget {

  // List of cards in the stack
  final List<PlayingCard> cards;

  // Callback when card is added to the stack
  final CardAcceptCallback onCardsAdded;

  // The index of the list in the game
  final int columnIndex;

  const CardColumn(
      {super.key, required this.cards,
        required this.onCardsAdded,
        required this.columnIndex});

  @override
  CardColumnState createState() => CardColumnState();
}

class CardColumnState extends State<CardColumn> {
  @override
  Widget build(BuildContext context) {
    final cardWidth = CardDimensions.calculateCardWidth(context);

    return SizedBox(
      height: 13.0 * CardDimensions.calculateCardHeight(cardWidth),
      width: cardWidth,
      child: DragTarget<Map>(
        builder: (context, listOne, listTwo) {
          return Stack(
            children: widget.cards.map((card) {
              int index = widget.cards.indexOf(card);


              // Calculate the offset for the current card
              var offset = 0.0;
              for (int i = 0; i < index; i++) {
              offset += widget.cards[i].faceUp ? 20.0 : 8.0; // Use appropriate distances
              }

              return Transform(
              transform: Matrix4.identity()..translate(0.0, offset, 0.0),
              child: TransformedCard(
              playingCard: card,
              transformIndex: index,
              attachedCards: widget.cards.sublist(index, widget.cards.length),
              columnIndex: widget.columnIndex, 

              transformDistance: 20.0,
              facedownDistance: 8.0,
              ),
              );
            }).toList(),
          );
        },
        onWillAcceptWithDetails: (value) {
          if (widget.cards.isEmpty) {
            return true;
          }

          List<PlayingCard> draggedCards = value.data["cards"];
          PlayingCard firstCard = draggedCards.first;
          if (firstCard.cardColor == CardColor.red) {
            if (widget.cards.last.cardColor == CardColor.red) {
              return false;
            }

            int lastColumnCardIndex = CardRank.values
                .indexOf(widget.cards.last.cardRank);
            int firstDraggedCardIndex =
            CardRank.values.indexOf(firstCard.cardRank);

            if (lastColumnCardIndex != firstDraggedCardIndex + 1) {
              return false;
            }
          } else {
            if (widget.cards.last.cardColor == CardColor.black) {
              return false;
            }

            int lastColumnCardIndex = CardRank.values
                .indexOf(widget.cards.last.cardRank);
            int firstDraggedCardIndex =
            CardRank.values.indexOf(firstCard.cardRank);

            if (lastColumnCardIndex != firstDraggedCardIndex + 1) {
              return false;
            }
          }
          return true;
        },
        onAcceptWithDetails: (value) {
          widget.onCardsAdded(
            value.data["cards"],
            value.data["fromIndex"],
          );
        },
      ),
    );
  }
}