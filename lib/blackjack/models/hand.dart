// hand.dart

import 'playing_card.dart';

class Hand {
  List<PlayingCard> cards = [];


  int get totalValue {
    int total = cards.fold(0, (sum, card) => sum + card.value);
    int aceCount = cards.where((card) => card.rank == 'A').length;

    // Adjust for Aces if total is over 21
    while (total > 21 && aceCount > 0) {
      total -= 10;
      aceCount--;
    }

    return total;
  }
  
  // Add a card to the hand
  void addCard(PlayingCard card) {
    cards.add(card);
  }

  // Reset the hand (for new game rounds)
  void reset() {
    cards.clear();
  }
}
