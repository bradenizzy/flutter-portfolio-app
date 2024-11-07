// game_util.dart

import '../models/hand.dart';

class GameUtils {

  bool hasBlackjack(Hand hand) {
    return hand.totalValue == 21 && hand.cards.length == 2;
  }

  bool isSoft17(Hand hand) {
    return hand.totalValue == 17 && isSoft(hand);
  }

  bool isBust(Hand hand) {
    return hand.totalValue > 21;
  }

  bool isSoft(Hand hand) {
    // Check if there's an Ace in the hand
    bool hasAce = hand.cards.any((card) => card.rank == 'A');
    if (!hasAce) return false;

    if (hand.cards.length > 2) {
      int totalWithoutAces = hand.cards
          .where((card) => card.rank != 'A')
          .fold(0, (sum, card) => sum + card.value);
      
      int numAces = hand.cards.where((card) => card.rank == 'A').length;
      // let all aces but one be 1 and the remaining ace be 11
      int totalWithAceAsEleven = totalWithoutAces + (numAces - 1) + 11; 
      return totalWithAceAsEleven <= 21;

    } else {
      // If there are only 2 cards and one is an Ace, it’s always soft
      return true;
    }
  }

  // Basic strategy function
  String basicStrategy(Hand playerHand, Hand dealerHand) {
    bool boolSoft = isSoft(playerHand);
    bool isTwoCardHand = playerHand.cards.length == 2;
    int playerTotal = playerHand.totalValue;
    int dealerCardValue = dealerHand.cards.first.value;

    // First, check for natural blackjack
    if (hasBlackjack(playerHand)) {
      return 'Stand';
    }

    // // Then, Check for Surrender
    // String surrenderDecision = checkSurrender(playerTotal, dealerCardValue, isTwoCardHand, boolSoft);
    // if (surrenderDecision != "nope") return surrenderDecision;
    
    // Next, Check for Pairs to Split
    String toSplitDecision = checkPairToSplit(playerHand, dealerCardValue, isTwoCardHand);
    if (toSplitDecision != "nope") return toSplitDecision;
    
    // Then, Check for Soft Totals
    if (boolSoft){
      String softTotalDecision = checkSoftTotal(playerTotal, dealerCardValue, isTwoCardHand);
      if (softTotalDecision != "nope") return softTotalDecision;
    }

    // Then, Check for Hard Totals
    String hardTotalDecision = checkHardTotal(playerTotal, dealerCardValue, isTwoCardHand);
    if (hardTotalDecision != "nope") return hardTotalDecision;

    // Default action if none of the conditions are met
    return "Hit"; 
  }

  // static String checkSurrender(int playerTotal, int dealerCardValue, bool isTwoCardHand, bool isSoft) {
  //   if (!isSoft && playerTotal == 16 && [9, 10, 11].contains(dealerCardValue) && isTwoCardHand) {
  //     return "Surrender";
  //   } else if (!isSoft && playerTotal == 15 && dealerCardValue == 10 && isTwoCardHand) {
  //     return "Surrender";
  //   }
  //   return "nope";
  // }

  static String checkPairToSplit(Hand playerHand, int dealerCardValue, bool isTwoCardHand) {
    if (playerHand.cards[0].rank == playerHand.cards[1].rank && isTwoCardHand) {
        String pairCard = playerHand.cards.first.rank;
        if (pairCard == 'A'){
          return "Split";
        }
        else if (['10', 'J', 'Q', 'K'].contains(pairCard)){
            return "Stand";
        }
        else if (pairCard == '9' && [2, 3, 4, 5, 6, 8, 9].contains(dealerCardValue)){
            return "Split";
        }
        else if (pairCard == '8') {
            return "Split";
        }
        else if (pairCard == '7' && [2, 3, 4, 5, 6, 7].contains(dealerCardValue)){
            return "Split";
        }
        else if (pairCard == '6' && [2, 3, 4, 5, 6].contains(dealerCardValue)){
            return "Split";
        }
        else if (pairCard == '5' && [2, 3, 4, 5, 6, 7, 8, 9].contains(dealerCardValue)){
            return "Double";
        }
        else if (pairCard == '5'){
            return "Hit";
        }
        else if (pairCard == '4' && [5, 6].contains(dealerCardValue)){
            return "Split";
        }
        else if (pairCard == '3' && [2, 3, 4, 5, 6, 7].contains(dealerCardValue)){
            return "Split";
        }
        else if (pairCard == '2' && [2, 3, 4, 5, 6, 7].contains(dealerCardValue)){
            return "Split";
        }
    }
    return "nope";
  }

  static String checkSoftTotal(int playerTotal, int dealerCardValue, bool isTwoCardHand) {
    if (playerTotal == 20) {
      return "Stand";
    } else if (playerTotal == 19 && dealerCardValue == 6) {
      return isTwoCardHand ? "Double" : "Stand";
    } else if (playerTotal == 19) {
      return "Stand";
    } else if (playerTotal == 18 && [2, 3, 4, 5, 6].contains(dealerCardValue)) {
      return isTwoCardHand ? "Double" : "Stand";
    } else if (playerTotal == 18 && [9, 10, 11].contains(dealerCardValue)) {
      return "Hit";
    } else if (playerTotal == 18) {
      return "Stand";
    } else if (playerTotal == 17 && [3, 4, 5, 6].contains(dealerCardValue)) {
      return isTwoCardHand ? "Double" : "Hit";
    } else if (playerTotal == 17) {
      return "Hit";
    } else if (playerTotal == 16 && [4, 5, 6].contains(dealerCardValue)) {
      return isTwoCardHand ? "Double" : "Hit";
    } else if (playerTotal == 16) {
      return "Hit";
    } else if (playerTotal == 15 && [4, 5, 6].contains(dealerCardValue)) {
      return isTwoCardHand ? "Double" : "Hit";
    } else if (playerTotal == 15) {
      return "Hit";
    } else if (playerTotal == 14 && [5, 6].contains(dealerCardValue)) {
      return isTwoCardHand ? "Double" : "Hit";
    } else if (playerTotal == 14) {
      return "Hit";
    } else if (playerTotal == 13 && [5, 6].contains(dealerCardValue)) {
      return isTwoCardHand ? "Double" : "Hit";
    } else if (playerTotal == 13) {
      return "Hit";
    }
    return "nope";
  }


  static String checkHardTotal(int playerTotal, int dealerCardValue, bool isTwoCardHand) {
    if (playerTotal >= 17) {
      return "Stand";
    } else if (playerTotal == 16 && [2, 3, 4, 5, 6].contains(dealerCardValue)) {
      return "Stand";
    } else if (playerTotal == 16) {
      return "Hit";
    } else if (playerTotal == 15 && [2, 3, 4, 5, 6].contains(dealerCardValue)) {
      return "Stand";
    } else if (playerTotal == 15) {
      return "Hit";
    } else if (playerTotal == 14 && [2, 3, 4, 5, 6].contains(dealerCardValue)) {
      return "Stand";
    } else if (playerTotal == 14) {
      return "Hit";
    } else if (playerTotal == 13 && [2, 3, 4, 5, 6].contains(dealerCardValue)) {
      return "Stand";
    } else if (playerTotal == 13) {
      return "Hit";
    } else if (playerTotal == 12 && [4, 5, 6].contains(dealerCardValue)) {
      return "Stand";
    } else if (playerTotal == 12) {
      return "Hit";
    } else if (playerTotal == 11) {
      return isTwoCardHand ? "Double" : "Hit";
    } else if (playerTotal == 10 && [2, 3, 4, 5, 6, 7, 8, 9].contains(dealerCardValue)) {
      return isTwoCardHand ? "Double" : "Hit";
    } else if (playerTotal == 10) {
      return "Hit";
    } else if (playerTotal == 9 && [3, 4, 5, 6].contains(dealerCardValue)) {
      return isTwoCardHand ? "Double" : "Hit";
    } else if (playerTotal == 9) {
      return "Hit";
    }
    return "nope";
  }

}
