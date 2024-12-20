// card_creation.dart

enum CardSuit {
  spades,
  hearts,
  diamonds,
  clubs,
}

enum CardRank {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king
}

enum CardColor {
  red,
  black,
}

// Simple playing card model
class PlayingCard {
  CardSuit cardSuit;
  CardRank cardRank;
  bool faceUp;
  bool opened;

  PlayingCard({
    required this.cardSuit,
    required this.cardRank,
    this.faceUp = false,
    this.opened = false,
  });

  CardColor get cardColor {
    if (cardSuit == CardSuit.hearts || cardSuit == CardSuit.diamonds) {
      return CardColor.red;
    } else {
      return CardColor.black;
    }
  }
}
