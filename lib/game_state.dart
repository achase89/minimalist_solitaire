// game_state.dart

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:minimalist_solitaire/card_playing.dart';

class GameState {
  // Stores the cards on the seven columns
  List<PlayingCard> cardColumn1 = [];
  List<PlayingCard> cardColumn2 = [];
  List<PlayingCard> cardColumn3 = [];
  List<PlayingCard> cardColumn4 = [];
  List<PlayingCard> cardColumn5 = [];
  List<PlayingCard> cardColumn6 = [];
  List<PlayingCard> cardColumn7 = [];

  // Stores the card deck
  List<PlayingCard> stockPile = [];
  List<PlayingCard> wastePile = [];

  // Stores the card in the foundation piles
  List<PlayingCard> finalHeartsDeck = [];
  List<PlayingCard> finalDiamondsDeck = [];
  List<PlayingCard> finalSpadesDeck = [];
  List<PlayingCard> finalClubsDeck = [];

  // List to store game states
  List<List<List<PlayingCard>>> gameStates = [];
  int currentStateIndex = -1;

  // Callback function to handle win condition
  VoidCallback? onWin;

  static const int finalHeartsDeckIndex = 8;
  static const int finalDiamondsDeckIndex = 9;
  static const int finalSpadesDeckIndex = 10;
  static const int finalClubsDeckIndex = 11;

  void initialiseGame() {
    cardColumn1 = [];
    cardColumn2 = [];
    cardColumn3 = [];
    cardColumn4 = [];
    cardColumn5 = [];
    cardColumn6 = [];
    cardColumn7 = [];

    stockPile = [];
    wastePile = [];

    finalHeartsDeck = [];
    finalDiamondsDeck = [];
    finalSpadesDeck = [];
    finalClubsDeck = [];

    List<PlayingCard> allCards = [];

    gameStates.clear();
    currentStateIndex = -1;

    // Add all cards to deck
    for (var suit in CardSuit.values) {
      for (var rank in CardRank.values) {
        allCards.add(PlayingCard(
          cardRank: rank,
          cardSuit: suit,
          faceUp: false,
        ));
      }
    }

    allCards.shuffle();

    Random random = Random();

    // Add cards to columns and remaining to deck
    for (int i = 0; i < 28; i++) {
      int randomNumber = random.nextInt(allCards.length);

      if (i == 0) {
        PlayingCard card = allCards[randomNumber];
        cardColumn1.add(
          card
            ..opened = true
            ..faceUp = true,
        );
        allCards.removeAt(randomNumber);
      } else if (i > 0 && i < 3) {
        if (i == 2) {
          PlayingCard card = allCards[randomNumber];
          cardColumn2.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn2.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      } else if (i > 2 && i < 6) {
        if (i == 5) {
          PlayingCard card = allCards[randomNumber];
          cardColumn3.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn3.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      } else if (i > 5 && i < 10) {
        if (i == 9) {
          PlayingCard card = allCards[randomNumber];
          cardColumn4.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn4.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      } else if (i > 9 && i < 15) {
        if (i == 14) {
          PlayingCard card = allCards[randomNumber];
          cardColumn5.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn5.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      } else if (i > 14 && i < 21) {
        if (i == 20) {
          PlayingCard card = allCards[randomNumber];
          cardColumn6.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn6.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      } else {
        if (i == 27) {
          PlayingCard card = allCards[randomNumber];
          cardColumn7.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn7.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      }
    }

    stockPile = allCards;

    saveGameState();
  }

  void saveGameState() {
    final newState = [
      cardColumn1.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      cardColumn2.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      cardColumn3.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      cardColumn4.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      cardColumn5.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      cardColumn6.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      cardColumn7.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      stockPile.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      wastePile.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      finalHeartsDeck.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      finalDiamondsDeck.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      finalSpadesDeck.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
      finalClubsDeck.map((card) => PlayingCard(
          cardSuit: card.cardSuit,
          cardRank: card.cardRank,
          faceUp: card.faceUp)).toList(),
    ];
    gameStates = gameStates.sublist(0, currentStateIndex + 1);
    gameStates.add(newState);
    currentStateIndex++;
  }

  void undo() {
    if (currentStateIndex > 0) {
      currentStateIndex--;
      _applyGameState(gameStates[currentStateIndex]);
    }
  }

  void redo() {
    if (currentStateIndex < gameStates.length - 1) {
      currentStateIndex++;
      _applyGameState(gameStates[currentStateIndex]);
    }
  }

  void _applyGameState(List<List<PlayingCard>> state) {
    cardColumn1.clear();
    cardColumn1.addAll(state[0]);
    cardColumn2.clear();
    cardColumn2.addAll(state[1]);
    cardColumn3.clear();
    cardColumn3.addAll(state[2]);
    cardColumn4.clear();
    cardColumn4.addAll(state[3]);
    cardColumn5.clear();
    cardColumn5.addAll(state[4]);
    cardColumn6.clear();
    cardColumn6.addAll(state[5]);
    cardColumn7.clear();
    cardColumn7.addAll(state[6]);
    stockPile.clear();
    stockPile.addAll(state[7]);
    wastePile.clear();
    wastePile.addAll(state[8]);
    finalHeartsDeck.clear();
    finalHeartsDeck.addAll(state[9]);
    finalDiamondsDeck.clear();
    finalDiamondsDeck.addAll(state[10]);
    finalSpadesDeck.clear();
    finalSpadesDeck.addAll(state[11]);
    finalClubsDeck.clear();
    finalClubsDeck.addAll(state[12]);
  }

  void moveCards(int fromIndex, int toIndex, List<PlayingCard> cards) {
    getListFromIndex(toIndex).addAll(cards);
    int length = getListFromIndex(fromIndex).length;
    getListFromIndex(fromIndex).removeRange(length - cards.length, length);
    refreshList(getListFromIndex(fromIndex)); // Call with fromIndex

    // Check for win condition after the move
    if (checkWinCondition()) {
      if (onWin != null) {
        onWin!(); // Call the onWin callback if it's set
      }
    }
  }

  void refreshList(List<PlayingCard> list) {
    if (list.isNotEmpty) {
      if (kDebugMode) {
        print('Flipping card ${list.last.cardRank} of ${list.last.cardSuit}');
      }
      list[list.length - 1]
        ..opened = true
        ..faceUp = true;
    }
  }

  bool checkWinCondition() {
    return finalDiamondsDeck.length +
        finalHeartsDeck.length +
        finalClubsDeck.length +
        finalSpadesDeck.length ==
        52;
  }

  List<PlayingCard> getListFromIndex(int index) {
    switch (index) {
      case 0:
        return wastePile;
      case 1:
        return cardColumn1;
      case 2:
        return cardColumn2;
      case 3:
        return cardColumn3;
      case 4:
        return cardColumn4;
      case 5:
        return cardColumn5;
      case 6:
        return cardColumn6;
      case 7:
        return cardColumn7;
      case 8:
        return finalHeartsDeck;
      case 9:
        return finalDiamondsDeck;
      case 10:
        return finalSpadesDeck;
      case 11:
        return finalClubsDeck;
      default:
        return [];
    }
  }

}