// card.dart

class PlayingCard {
  final String suit;
  final String rank;

  PlayingCard({required this.suit, required this.rank});

  // Calculate value based on rank
  int get value {
    const Map<String, int> cardValues = {
      "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9,
      "10": 10, "J": 10, "Q": 10, "K": 10, "A": 11,
    };
    return cardValues[rank] ?? 0;
  } 
}
