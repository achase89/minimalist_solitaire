// card_movement.dart

// card_movement.dart

import 'package:minimalist_solitaire/card_creation.dart';
import 'package:minimalist_solitaire/game_state.dart';

class CardMovement {
  static void moveCards(
      int fromIndex, int toIndex, List<PlayingCard> cards, GameState gameState) {
    gameState.getListFromIndex(toIndex).addAll(cards);
    gameState.getListFromIndex(fromIndex)
        .removeWhere((card) => cards.contains(card));
    gameState.refreshList(gameState.getListFromIndex(fromIndex));
    if (gameState.checkWinCondition()) {
      if (gameState.onWin != null) {
        gameState.onWin!();
      }
    }
  }
  // handles card being moved to the foundations
  static void moveToFoundation(
      int fromIndex, List<PlayingCard> cards, GameState gameState) {
    // Add the cards to the appropriate foundation pile
    if (cards.first.cardSuit == CardSuit.hearts) {
      gameState.finalHeartsDeck.addAll(cards);
    } else if (cards.first.cardSuit == CardSuit.diamonds) {
      gameState.finalDiamondsDeck.addAll(cards);
    } else if (cards.first.cardSuit == CardSuit.spades) {
      gameState.finalSpadesDeck.addAll(cards);
    } else if (cards.first.cardSuit == CardSuit.clubs) {
      gameState.finalClubsDeck.addAll(cards);
    }

    // Remove the cards from the source column
    gameState.getListFromIndex(fromIndex).removeWhere((card) => cards.contains(card));

    // Refresh the source column and check for win condition
    gameState.refreshList(gameState.getListFromIndex(fromIndex));
    if (gameState.checkWinCondition()) {
      if (gameState.onWin != null) {
        gameState.onWin!();
      }
    }
  }

  // handles card being moved to a game column
  static void moveToColumn(int fromIndex, int toIndex, List<PlayingCard> cards,
      GameState gameState) {
    // Add the cards to the destination column
    gameState.getListFromIndex(toIndex).addAll(cards);

    // Remove the cards from the source column
    gameState.getListFromIndex(fromIndex)
        .removeWhere((card) => cards.contains(card));

    // Refresh the source column and check for win condition
    gameState.refreshList(gameState.getListFromIndex(fromIndex));
    if (gameState.checkWinCondition()) {
      if (gameState.onWin != null) {
        gameState.onWin!();
      }
    }
  }


}