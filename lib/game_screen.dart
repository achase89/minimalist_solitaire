import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minimalist_solitaire/card_column.dart';
import 'package:minimalist_solitaire/card_empty.dart';
import 'package:minimalist_solitaire/card_playing.dart';
import 'package:minimalist_solitaire/card_transformed.dart';
import 'card_dimensions.dart';

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
        actions: <Widget>[
          InkWell( // New game button
            splashColor: Colors.white,
            onTap: () {
              _initialiseGame();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  InkWell(
                    //Stock Pile
                    child: stockPile.isNotEmpty
                        ? TransformedCard(
                      playingCard: stockPile.last,
                      attachedCards: [
                        stockPile.last
                      ], // Added attachedCards argument
                      columnIndex: 0, // Added columnIndex argument
                    )
                        : Opacity(
                      opacity: 0.4,
                      child: TransformedCard(
                        playingCard: PlayingCard(
                          cardSuit: CardSuit.diamonds,
                          cardRank: CardRank.five,
                        ),
                        attachedCards: [
                          PlayingCard(
                            cardSuit: CardSuit.diamonds,
                            cardRank: CardRank.five,
                          ),
                        ], // Added attachedCards argument
                        columnIndex: 0, // Added columnIndex argument
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (stockPile.isEmpty) {
                          stockPile.addAll(wastePile.map((card) {
                            return card
                              ..opened = false
                              ..faceUp = false;
                          }));
                          wastePile.clear();
                        } else {
                          wastePile.add(
                            stockPile.removeLast()
                              ..faceUp = true
                              ..opened = true,
                          );
                        }
                      });
                    },
                  ),
                  //Waste Pile
                  wastePile.isNotEmpty
                      ? TransformedCard(
                    playingCard: wastePile.last,
                    attachedCards: [
                      wastePile.last,
                    ],
                    columnIndex: 0,
                  )
                      : SizedBox(
                    width: cardWidth,
                  ),
                  SizedBox(width: cardWidth),
                  //Foundation Piles
                  EmptyCardDeck(
                    cardSuit: CardSuit.hearts,
                    cardsAdded: finalHeartsDeck,
                    onCardAdded: (cards, index) {
                      finalHeartsDeck.addAll(cards);
                      int length = _getListFromIndex(index).length;
                      _getListFromIndex(index)
                          .removeRange(length - cards.length, length);
                      _refreshList(index);
                    },
                    columnIndex: 8,
                  ),
                  EmptyCardDeck(
                    cardSuit: CardSuit.diamonds,
                    cardsAdded: finalDiamondsDeck,
                    onCardAdded: (cards, index) {
                      finalDiamondsDeck.addAll(cards);
                      int length = _getListFromIndex(index).length;
                      _getListFromIndex(index)
                          .removeRange(length - cards.length, length);
                      _refreshList(index);
                    },
                    columnIndex: 9,
                  ),
                  EmptyCardDeck(
                    cardSuit: CardSuit.spades,
                    cardsAdded: finalSpadesDeck,
                    onCardAdded: (cards, index) {
                      finalSpadesDeck.addAll(cards);
                      int length = _getListFromIndex(index).length;
                      _getListFromIndex(index)
                          .removeRange(length - cards.length, length);
                      _refreshList(index);
                    },
                    columnIndex: 10,
                  ),
                  EmptyCardDeck(
                    cardSuit: CardSuit.clubs,
                    cardsAdded: finalClubsDeck,
                    onCardAdded: (cards, index) {
                      finalClubsDeck.addAll(cards);
                      int length = _getListFromIndex(index).length;
                      _getListFromIndex(index)
                          .removeRange(length - cards.length, length);
                      _refreshList(index);
                    },
                    columnIndex: 11,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox( // Card Column 1
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
                        });
                      },
                      columnIndex: 1,
                    ),
                  ),
                  SizedBox( // Card Column 2
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
                        });
                      },
                      columnIndex: 2,
                    ),
                  ),
                  SizedBox( // Card Column 3
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
                        });
                      },
                      columnIndex: 3,
                    ),
                  ),
                  SizedBox( // Card Column 4
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
                        });
                      },
                      columnIndex: 4,
                    ),
                  ),
                  SizedBox( // Card Column 5
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
                        });
                      },
                      columnIndex: 5,
                    ),
                  ),
                  SizedBox( // Card Column 6
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
                        });
                      },
                      columnIndex: 6,
                    ),
                  ),
                  SizedBox( // Card Column 7
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
                        });
                      },
                      columnIndex: 7,
                    ),
                  ),
                ],
              ),
            ),
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
    wastePile.add(
      stockPile.removeLast()
        ..opened = true
        ..faceUp = true,
    );

    setState(() {});
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