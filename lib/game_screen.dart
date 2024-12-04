// game_screen.dart

import 'dart:math';

import 'package:flutter/material.dart';

import 'card_column.dart';
import 'card_dimensions.dart';
import 'card_empty.dart';
import 'card_playing.dart';
import 'card_transformed.dart';
import 'card_placeholder.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  // Stores the cards on the seven columns
  List<PlayingCard> cardColumn1 = [];
  List<PlayingCard> cardColumn2 = [];
  List<PlayingCard> cardColumn3 = [];
  List<PlayingCard> cardColumn4 = [];
  List<PlayingCard> cardColumn5 = [];
  List<PlayingCard> cardColumn6 = [];
  List<PlayingCard> cardColumn7 = [];

  // Stores the card deck
  // List to store the closed card deck (stock pile)
  List<PlayingCard> stockPile = [];
  // List to store the opened card deck (waste pile)
  List<PlayingCard> wastePile = [];

  // Stores the card in the foundation piles
  List<PlayingCard> finalHeartsDeck = [];
  List<PlayingCard> finalDiamondsDeck = [];
  List<PlayingCard> finalSpadesDeck = [];
  List<PlayingCard> finalClubsDeck = [];

  // List to store game states
  List<List<List<PlayingCard>>> gameStates = [];
  int currentStateIndex = -1;

  @override
  void initState() {
    super.initState();
    _initialiseGame();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = CardDimensions.calculateCardWidth(context);

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text("Minimalist Solitaire"),
        elevation: 0.0,
        backgroundColor: Colors.green,
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
                    child: stockPile.isNotEmpty
                        ? TransformedCard(
                            playingCard: stockPile.last,
                            attachedCards: [stockPile.last],
                            columnIndex: 0,
                          )
                        : const CardPlaceholder(),
                    onTap: () {
                      setState(() {
                        if (stockPile.isEmpty) {
                          stockPile.addAll(wastePile.reversed.map((card) => card
                            ..faceUp = false
                            ..opened = false)); // Reset opened to false
                          wastePile.clear();
                        } else {
                          wastePile.add(
                            stockPile.removeLast()
                              ..faceUp = true
                              ..opened = true,
                          );
                        }
                        _saveGameState();
                      });
                    },
                  ),
                  // Waste pile
                  wastePile.isNotEmpty
                      ? TransformedCard(
                          playingCard: wastePile.last,
                          attachedCards: [wastePile.last],
                          columnIndex: 0,
                        )
                      : const CardPlaceholder(),

                  // Spacer between waste pile and foundation piles
                  SizedBox(
                      width:
                          cardWidth), // Spacer between waste pile and foundation piles

                  //Foundation Piles
                  EmptyCardDeck(
                    cardSuit: CardSuit.hearts,
                    cardsAdded: finalHeartsDeck,
                    onCardAdded: (cards, index) {
                      setState(() {
                        finalHeartsDeck.addAll(cards);
                        int length = _getListFromIndex(index).length;
                        _getListFromIndex(index)
                            .removeRange(length - cards.length, length);
                        _refreshList(index);
                        _saveGameState();
                      });
                    },
                    columnIndex: 8,
                  ),
                  EmptyCardDeck(
                    cardSuit: CardSuit.diamonds,
                    cardsAdded: finalDiamondsDeck,
                    onCardAdded: (cards, index) {
                      setState(() {
                        finalDiamondsDeck.addAll(cards);
                        int length = _getListFromIndex(index).length;
                        _getListFromIndex(index)
                            .removeRange(length - cards.length, length);
                        _refreshList(index);
                        _saveGameState();
                      });
                    },
                    columnIndex: 9,
                  ),
                  EmptyCardDeck(
                    cardSuit: CardSuit.spades,
                    cardsAdded: finalSpadesDeck,
                    onCardAdded: (cards, index) {
                      setState(() {
                        finalSpadesDeck.addAll(cards);
                        int length = _getListFromIndex(index).length;
                        _getListFromIndex(index)
                            .removeRange(length - cards.length, length);
                        _refreshList(index);
                        _saveGameState();
                      });
                    },
                    columnIndex: 10,
                  ),
                  EmptyCardDeck(
                    cardSuit: CardSuit.clubs,
                    cardsAdded: finalClubsDeck,
                    onCardAdded: (cards, index) {
                      setState(() {
                        finalClubsDeck.addAll(cards);
                        int length = _getListFromIndex(index).length;
                        _getListFromIndex(index)
                            .removeRange(length - cards.length, length);
                        _refreshList(index);
                        _saveGameState();
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
                      cards: cardColumn1,
                      onCardsAdded: (cards, index) {
                        setState(() {
                          cardColumn1.addAll(cards);
                          int length = _getListFromIndex(index).length;
                          _getListFromIndex(index)
                              .removeRange(length - cards.length, length);
                          _refreshList(index);
                          _saveGameState();
                        });
                      },
                      columnIndex: 1,
                    ),
                  ),
                  SizedBox(
                    // Card Column 2
                    width: cardWidth,
                    child: CardColumn(
                      cards: cardColumn2,
                      onCardsAdded: (cards, index) {
                        setState(() {
                          cardColumn2.addAll(cards);
                          int length = _getListFromIndex(index).length;
                          _getListFromIndex(index)
                              .removeRange(length - cards.length, length);
                          _refreshList(index);
                          _saveGameState();
                        });
                      },
                      columnIndex: 2,
                    ),
                  ),
                  SizedBox(
                    // Card Column 3
                    width: cardWidth,
                    child: CardColumn(
                      cards: cardColumn3,
                      onCardsAdded: (cards, index) {
                        setState(() {
                          cardColumn3.addAll(cards);
                          int length = _getListFromIndex(index).length;
                          _getListFromIndex(index)
                              .removeRange(length - cards.length, length);
                          _refreshList(index);
                          _saveGameState();
                        });
                      },
                      columnIndex: 3,
                    ),
                  ),
                  SizedBox(
                    // Card Column 4
                    width: cardWidth,
                    child: CardColumn(
                      cards: cardColumn4,
                      onCardsAdded: (cards, index) {
                        setState(() {
                          cardColumn4.addAll(cards);
                          int length = _getListFromIndex(index).length;
                          _getListFromIndex(index)
                              .removeRange(length - cards.length, length);
                          _refreshList(index);
                          _saveGameState();
                        });
                      },
                      columnIndex: 4,
                    ),
                  ),
                  SizedBox(
                    // Card Column 5
                    width: cardWidth,
                    child: CardColumn(
                      cards: cardColumn5,
                      onCardsAdded: (cards, index) {
                        setState(() {
                          cardColumn5.addAll(cards);
                          int length = _getListFromIndex(index).length;
                          _getListFromIndex(index)
                              .removeRange(length - cards.length, length);
                          _refreshList(index);
                          _saveGameState();
                        });
                      },
                      columnIndex: 5,
                    ),
                  ),
                  SizedBox(
                    // Card Column 6
                    width: cardWidth,
                    child: CardColumn(
                      cards: cardColumn6,
                      onCardsAdded: (cards, index) {
                        setState(() {
                          cardColumn6.addAll(cards);
                          int length = _getListFromIndex(index).length;
                          _getListFromIndex(index)
                              .removeRange(length - cards.length, length);
                          _refreshList(index);
                          _saveGameState();
                        });
                      },
                      columnIndex: 6,
                    ),
                  ),
                  SizedBox(
                    // Card Column 7
                    width: cardWidth,
                    child: CardColumn(
                      cards: cardColumn7,
                      onCardsAdded: (cards, index) {
                        setState(() {
                          cardColumn7.addAll(cards);
                          int length = _getListFromIndex(index).length;
                          _getListFromIndex(index)
                              .removeRange(length - cards.length, length);
                          _refreshList(index);
                          _saveGameState();
                        });
                      },
                      columnIndex: 7,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Game options row
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Distribute buttons evenly
            children: [
              IconButton(
                // Undo button
                icon: const Icon(Icons.undo),
                onPressed:
                    currentStateIndex > 0 ? _undo : null, // Disable if no undo
                color: currentStateIndex > 0 ? Colors.white : Colors.grey,
              ),
              IconButton(
                // New game button
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  _initialiseGame();
                },
              ),
              IconButton(
                // Redo button
                icon: const Icon(Icons.redo),
                onPressed: currentStateIndex < gameStates.length - 1
                    ? _redo
                    : null, // Disable if no redo
                color: currentStateIndex < gameStates.length - 1
                    ? Colors.white
                    : Colors.grey, // Change color based on state
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Initialise a new game
  void _initialiseGame() {
    cardColumn1 = [];
    cardColumn2 = [];
    cardColumn3 = [];
    cardColumn4 = [];
    cardColumn5 = [];
    cardColumn6 = [];
    cardColumn7 = [];

    // Stores the card deck
    stockPile = [];
    wastePile = [];

    // Stores the card in the upper boxes
    finalHeartsDeck = [];
    finalDiamondsDeck = [];
    finalSpadesDeck = [];
    finalClubsDeck = [];

    List<PlayingCard> allCards = [];

    gameStates.clear(); // Clear the game states list
    currentStateIndex = -1; // Reset the current state index

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

    allCards.shuffle(); // Shuffle the deck here

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

    // Initialize game state
    _saveGameState();

    setState(() {});
  }

  void _saveGameState() {
    final newState = [
      cardColumn1
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      cardColumn2
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      cardColumn3
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      cardColumn4
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      cardColumn5
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      cardColumn6
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      cardColumn7
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      stockPile
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      wastePile
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      finalHeartsDeck
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      finalDiamondsDeck
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      finalSpadesDeck
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
      finalClubsDeck
          .map((card) => PlayingCard(
              cardSuit: card.cardSuit,
              cardRank: card.cardRank,
              faceUp: card.faceUp))
          .toList(),
    ];
    gameStates = gameStates.sublist(0, currentStateIndex + 1);
    gameStates.add(newState);
    currentStateIndex++;
  }

  void _undo() {
    if (currentStateIndex > 0) {
      currentStateIndex--;
      _applyGameState(gameStates[currentStateIndex]);
      setState(() {});
    }
  }

  void _redo() {
    if (currentStateIndex < gameStates.length - 1) {
      currentStateIndex++;
      _applyGameState(gameStates[currentStateIndex]);
      setState(() {});
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

  void _refreshList(int index) {
    if (finalDiamondsDeck.length +
            finalHeartsDeck.length +
            finalClubsDeck.length +
            finalSpadesDeck.length ==
        52) {
      _handleWin();
    }
    setState(() {
      if (_getListFromIndex(index).isNotEmpty) {
        _getListFromIndex(index)[_getListFromIndex(index).length - 1]
          ..opened = true
          ..faceUp = true;
      }
    });
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
                _initialiseGame();
                Navigator.pop(context);
              },
              child: const Text("Play again"),
            ),
          ],
        );
      },
    );
  }

  List<PlayingCard> _getListFromIndex(int index) {
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
