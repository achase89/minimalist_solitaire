// game_screen.dart

import 'package:flutter/material.dart';
import 'package:minimalist_solitaire/card_playing.dart';
import 'package:minimalist_solitaire/game_state.dart'; // Import your GameState class

import 'card_column.dart';
import 'card_dimensions.dart';
import 'card_empty.dart';
import 'card_placeholder.dart';
import 'card_transformed.dart';
import 'styles.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenManager createState() => GameScreenManager();
}

class GameScreenManager extends State<GameScreen> {
  late GameState gameState; // Declare gameState

  @override
  void initState() {
    super.initState();
    gameState = GameState(); // Initialise gameState
    gameState.initialiseGame(); // Call initialiseGame
    gameState.onWin = _handleWin; // Call handleWin
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = CardDimensions.calculateCardWidth(context);

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: const Text("Minimalist Solitaire"),
        backgroundColor: AppStyles.backgroundColor,
      ),
      body: Column(
        children: <Widget>[
          // Stock, waste, and foundations
          Flexible(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //Stock Pile
                  InkWell(
                    child: gameState.stockPile.isNotEmpty
                        ? TransformedCard(
                            playingCard: gameState.stockPile.last,
                            attachedCards: [gameState.stockPile.last],
                            columnIndex: 0,
                          )
                        : const CardPlaceholder(),
                    onTap: () {
                      setState(() {
                        if (gameState.stockPile.isEmpty) {
                          gameState.stockPile.addAll(
                              gameState.wastePile.reversed.map((card) => card
                                ..faceUp = false
                                ..opened = false)); // Reset opened to false
                          gameState.wastePile.clear();
                        } else {
                          gameState.wastePile.add(
                            gameState.stockPile.removeLast()
                              ..faceUp = true
                              ..opened = true,
                          );
                        }
                        gameState.saveGameState();
                      });
                    },
                  ),
                  // Waste pile
                  gameState.wastePile.isNotEmpty
                      ? TransformedCard(
                          playingCard: gameState.wastePile.last,
                          attachedCards: [gameState.wastePile.last],
                          columnIndex: 0,
                        )
                      : const CardPlaceholder(),

                  // Spacer between waste pile and foundation piles
                  SizedBox(
                      width:
                          cardWidth), // Spacer between waste pile and foundation piles

                  //Foundation Piles
                  FoundationPile(
                    cardSuit: CardSuit.hearts,
                    cardsAdded: gameState.finalHeartsDeck,
                    onCardAddedToFoundation: (cards, index) {
                      setState(() {
                        gameState.moveCards(
                            index, GameState.finalHeartsDeckIndex, cards);
                        gameState.saveGameState();
                      });
                    },
                    columnIndex: 8,
                  ),
                  FoundationPile(
                    cardSuit: CardSuit.diamonds,
                    cardsAdded: gameState.finalDiamondsDeck,
                    onCardAddedToFoundation: (cards, index) {
                      setState(() {
                        gameState.moveCards(
                            index, GameState.finalDiamondsDeckIndex, cards);
                        gameState.saveGameState();
                      });
                    },
                    columnIndex: 9,
                  ),
                  FoundationPile(
                    cardSuit: CardSuit.spades,
                    cardsAdded: gameState.finalSpadesDeck,
                    onCardAddedToFoundation: (cards, index) {
                      setState(() {
                        gameState.moveCards(
                            index, GameState.finalSpadesDeckIndex, cards);
                        gameState.saveGameState();
                      });
                    },
                    columnIndex: 10,
                  ),
                  FoundationPile(
                    cardSuit: CardSuit.clubs,
                    cardsAdded: gameState.finalClubsDeck,
                    onCardAddedToFoundation: (cards, index) {
                      setState(() {
                        gameState.moveCards(
                            index, GameState.finalClubsDeckIndex, cards);
                        gameState.saveGameState();
                      });
                    },
                    columnIndex: 11,
                  ),
                ],
              ),
            ),
          ),
          // Game columns
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    // Card Column 1
                    width: cardWidth,
                    child: CardColumn(
                      cards: gameState.cardColumn1,
                      onCardsAddedToColumn: (cards, fromIndex) {
                        setState(() {
                          gameState.moveCards(fromIndex, 1, cards);
                          gameState.saveGameState();
                        });
                      },
                      columnIndex: 1,
                    ),
                  ),
                  SizedBox(
                    // Card Column 2
                    width: cardWidth,
                    child: CardColumn(
                      cards: gameState.cardColumn2,
                      onCardsAddedToColumn: (cards, fromIndex) {
                        setState(() {
                          gameState.moveCards(fromIndex, 2, cards);
                          gameState.saveGameState();
                        });
                      },
                      columnIndex: 2,
                    ),
                  ),
                  SizedBox(
                    // Card Column 3
                    width: cardWidth,
                    child: CardColumn(
                      cards: gameState.cardColumn3,
                      onCardsAddedToColumn: (cards, fromIndex) {
                        setState(() {
                          gameState.moveCards(fromIndex, 3, cards);
                          gameState.saveGameState();
                        });
                      },
                      columnIndex: 3,
                    ),
                  ),
                  SizedBox(
                    // Card Column 4
                    width: cardWidth,
                    child: CardColumn(
                      cards: gameState.cardColumn4,
                      onCardsAddedToColumn: (cards, fromIndex) {
                        setState(() {
                          gameState.moveCards(fromIndex, 4, cards);
                          gameState.saveGameState();
                        });
                      },
                      columnIndex: 4,
                    ),
                  ),
                  SizedBox(
                    // Card Column 5
                    width: cardWidth,
                    child: CardColumn(
                      cards: gameState.cardColumn5,
                      onCardsAddedToColumn: (cards, fromIndex) {
                        setState(() {
                          gameState.moveCards(fromIndex, 5, cards);
                          gameState.saveGameState();
                        });
                      },
                      columnIndex: 5,
                    ),
                  ),
                  SizedBox(
                    // Card Column 6
                    width: cardWidth,
                    child: CardColumn(
                      cards: gameState.cardColumn6,
                      onCardsAddedToColumn: (cards, fromIndex) {
                        setState(() {
                          gameState.moveCards(fromIndex, 6, cards);
                          gameState.saveGameState();
                        });
                      },
                      columnIndex: 6,
                    ),
                  ),
                  SizedBox(
                    // Card Column 7
                    width: cardWidth,
                    child: CardColumn(
                      cards: gameState.cardColumn7,
                      onCardsAddedToColumn: (cards, fromIndex) {
                        setState(() {
                          gameState.moveCards(fromIndex, 7, cards);
                          gameState.saveGameState();
                        });
                      },
                      columnIndex: 7,
                    ),
                  ),
                ],
              ),
            ),
          ),
// Game options
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ElevatedButton(
                    onPressed: gameState.currentStateIndex > 0
                        ? () {
                            setState(() {
                              gameState.undo();
                            });
                          }
                        : null,
                    style: AppStyles.pillShapedButtonStyle(
                      // Use the style from styles.dart
                      activeColor: AppStyles.buttonActiveIconColor,
                      inactiveColor: AppStyles.buttonInactiveIconColor,
                      onPressColor: AppStyles.buttonOnPressIconColor,
                      icon: Icons.undo,
                    ),
                    child: const Icon(Icons.undo),
                  ),
                ), // Undo button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameState.initialiseGame();
                      });
                    },
                    style: AppStyles.pillShapedButtonStyle(
                      // Use the style from styles.dart
                      activeColor: AppStyles.buttonActiveIconColor,
                      inactiveColor: AppStyles.buttonInactiveIconColor,
                      onPressColor: AppStyles.buttonOnPressIconColor,
                      icon: Icons.refresh,
                    ),
                    child: const Icon(Icons.refresh),
                  ),
                ), // New game button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ElevatedButton(
                    onPressed: gameState.currentStateIndex <
                            gameState.gameStates.length - 1
                        ? () {
                            setState(() {
                              gameState.redo();
                            });
                          }
                        : null,
                    style: AppStyles.pillShapedButtonStyle(
                      // Use the style from styles.dart
                      activeColor: AppStyles.buttonActiveIconColor,
                      inactiveColor: AppStyles.buttonInactiveIconColor,
                      onPressColor: AppStyles.buttonOnPressIconColor,
                      icon: Icons.redo,
                    ),
                    child: const Icon(Icons.redo),
                  ),
                ), // redo button
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Handle a win condition
  void _handleWin() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text("You Win!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                gameState.initialiseGame();
                Navigator.pop(context);
              },
              child: const Text("Play again"),
            ),
          ],
        );
      },
    );
  }
}
