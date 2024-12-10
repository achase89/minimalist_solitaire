// card_piles.dart

import 'package:flutter/material.dart';
import 'package:minimalist_solitaire/card_creation.dart';
import 'package:minimalist_solitaire/card_visuals.dart';

import 'card_dimensions.dart';
import 'game_state.dart';

typedef CardAcceptCallback = Null Function(
    List<PlayingCard> card, int fromIndex);

// This is a stack of overlayed cards (implemented using a stack)
class CardColumn extends StatefulWidget {
  // List of cards in the stack
  final List<PlayingCard> cards;
  final GameState gameState;

  // Callback when card is added to the stack
  final CardAcceptCallback onCardsAddedToColumn;

  // The index of the list in the game
  final int columnIndex;

  const CardColumn({
    super.key,
    required this.cards,
    required this.onCardsAddedToColumn,
    required this.columnIndex,
    required this.gameState,
  });

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
            children: widget.cards.asMap().entries.map((entry) {
              final card = entry.value;
              final index = entry.key;

              // Calculate the offset for the current card
              var offset = 0.0;
              for (int i = 0; i < index; i++) {
                offset += widget.cards[i].faceUp ? 20.0 : 8.0;
              }

              // In card_piles.dart, inside the builder method

              // Find the index of the first face-up card in the column
              int firstFaceUpIndex = widget.cards.indexWhere((card) => card.faceUp);

              // If no face-up cards are found, set firstFaceUpIndex to the column length
              if (firstFaceUpIndex == -1) {
                firstFaceUpIndex = widget.cards.length;
              }

              String attachedCardsString = widget.cards
                  .sublist(firstFaceUpIndex + 1, widget.cards.length)
                  .map((card) => '${card.cardRank} of ${card.cardSuit}')
                  .join(' attached to ');

              // Print only for the first face-up card
              if (index == firstFaceUpIndex) {
                print('In column ${widget.columnIndex} is a ${card.cardRank} of ${card.cardSuit} attached to $attachedCardsString');
              }

              return Transform(
                transform: Matrix4.identity()..translate(0.0, offset, 0.0),
                child: TransformedCard(
                  playingCard: card,
                  transformIndex: index,
                  attachedCards: widget.cards.sublist(
                      index, widget.cards.length),
                  columnIndex: widget.columnIndex,
                  transformDistance: 20.0,
                  facedownDistance: 8.0,
                  gameState: widget.gameState,
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

            int lastColumnCardIndex =
                CardRank.values.indexOf(widget.cards.last.cardRank);
            int firstDraggedCardIndex =
                CardRank.values.indexOf(firstCard.cardRank);

            if (lastColumnCardIndex != firstDraggedCardIndex + 1) {
              return false;
            }
          } else {
            if (widget.cards.last.cardColor == CardColor.black) {
              return false;
            }

            int lastColumnCardIndex =
                CardRank.values.indexOf(widget.cards.last.cardRank);
            int firstDraggedCardIndex =
                CardRank.values.indexOf(firstCard.cardRank);

            if (lastColumnCardIndex != firstDraggedCardIndex + 1) {
              return false;
            }
          }
          return true;
        },
        onAcceptWithDetails: (value) {
          widget.onCardsAddedToColumn(
            value.data["cards"],
            value.data["fromIndex"],
          );
        },
      ),
    );
  }
}
