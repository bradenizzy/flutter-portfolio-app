// game_provider.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../models/hand.dart';
import '../models/playing_card.dart';
import '../utils/game_util.dart';

class GameProvider extends ChangeNotifier {

  GameUtils gameUtils = GameUtils();

  final Map<String, int> cardValues = {
    "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9,
    "10": 10, "J": 10, "Q": 10, "K": 10, "A": 11,
  };
  List<PlayingCard> deck = [];
  int cutCardPosition = 0;
  int _numDecks = 1;
  int runningCount = 0;

  List<Hand> playerHands = [Hand()];
  int activeHandIndex = 0; 
  Hand dealerHand = Hand();
  bool isDealerTurn = false;
  bool isPlayerTurn = true;
  String? feedback;
  //bool surrendered = false;
  bool isGameOver = false;
  List<String> handResults = [];
  bool isRoundOver = false;

  // stats
  int correctActions = 0;
  int incorrectActions = 0;
  int wins = 0;
  int losses = 0;
  int ties = 0;
  int handsPlayed = 0;
  

  // update running count based on card dealt
  void updateRunningCount(PlayingCard card) {
    if (["2", "3", "4", "5", "6"].contains(card.rank)) {
      runningCount += 1;
    } else if (["10", "J", "Q", "K", "A"].contains(card.rank)) {
      runningCount -= 1;
    }
    notifyListeners();
  }

  void dealCardToPlayer(int handIndex) {
    if (deck.isNotEmpty) {
      PlayingCard dealtCard = deck.removeLast();
      playerHands[handIndex].addCard(dealtCard);
      notifyListeners();
      updateRunningCount(dealtCard);
    }
  }

  void dealCardToDealer() {
    if (deck.isNotEmpty) {
      PlayingCard dealtCard = deck.removeLast();
      dealerHand.addCard(dealtCard);
      notifyListeners();
      updateRunningCount(dealtCard);
    }
  }

  void hit() {
    bool correctAction = handlePlayerAction("Hit");
    if (correctAction) {
      dealCardToPlayer(activeHandIndex);
      checkPlayerBust();
    }
  }

  void stand() {
    bool correctAction = handlePlayerAction("Stand");
    if (correctAction) {
      notifyListeners();
      checkPlayerContinue();
    }
  }

  void split() {
    bool correctAction = handlePlayerAction("Split");
    if (correctAction) {
      Hand newHand = Hand();
      newHand.addCard(playerHands[activeHandIndex].cards.removeLast());
      playerHands.insert(activeHandIndex + 1, newHand);
      notifyListeners();
      dealCardToPlayer(activeHandIndex);
      dealCardToPlayer(activeHandIndex + 1);
    }
  }

  void doubleDown() {
      bool correctAction = handlePlayerAction("Double");
      if (correctAction) {
        playerHands[activeHandIndex].addCard(deck.removeLast());
        notifyListeners();
        checkPlayerContinue();
    }
  }

  // Future<void> surrender() async {
  //   bool correctAction = handlePlayerAction("Surrender");
  //   if (correctAction) {
  //     if (activeHandIndex == playerHands.length - 1) {
  //       isPlayerTurn = false;
  //       isDealerTurn = true;
  //       surrendered = true;
  //       notifyListeners();
  //       await Future.delayed(Duration(seconds: 1));
  //       determineOutcome(surrendered);
  //     } else {
  //       handResults.add('surrender');
  //       moveToNextHand();
  //     }
  //   }
  // }

  void showFeedback(String message) {
    feedback = message;
    notifyListeners();

    // Set a timer to clear the feedback after 3 seconds
    Timer(Duration(seconds: 2), () {
      clearFeedback();
    });
  }

  void clearFeedback() {
    feedback = null;
    notifyListeners();
  }

  void updateFeedback(String message) {
    feedback = message;
    notifyListeners();
  }

  bool handlePlayerAction(String playerAction) {
    final playerHand = playerHands[activeHandIndex];
    String message = "";
    String recommendedAction = gameUtils.basicStrategy(playerHand, dealerHand);

    if (playerAction == recommendedAction) {
      message = "Correct! You should $playerAction.";
      correctActions++;
      notifyListeners();
      showFeedback(message);
      //updateFeedback(message);
      return true;
    } else {
      message = "Incorrect. You should $recommendedAction. Please try again.";
      incorrectActions++;
      notifyListeners();
      showFeedback(message);
      //updateFeedback(message);
      return false;
    }
  }

  void shuffleDeck() {
    deck.clear();
    for (int i = 0; i < _numDecks; i++) {
      for (String rank in cardValues.keys) {
        deck.addAll([
          PlayingCard(suit: 'Hearts', rank: rank),
          PlayingCard(suit: 'Diamonds', rank: rank),
          PlayingCard(suit: 'Clubs', rank: rank),
          PlayingCard(suit: 'Spades', rank: rank),
        ]);
      }
    }
    deck.shuffle();

    // Set the cut card position to be around 15% into the deck
    cutCardPosition = ((0.15 * deck.length).toInt() + Random().nextInt((0.05 * deck.length).toInt())).toInt();
    notifyListeners();
  }

  // set the number of decks from player input
  int get numDecks => _numDecks;
  set numDecks(int value) {
    _numDecks = value;
    notifyListeners(); 
  }

  bool enoughCardsForRound() {
    return deck.length > cutCardPosition;
  }

  // 1st function called
  void startGame() {
    resetGame();
    startRound();
  }

  // 2nd function called
  void startRound() {
    if (enoughCardsForRound()) {
      resetRound();
    } else {
      endGame();
    }
  }

  void endGame() {
    isGameOver = true;
    notifyListeners();
  }

  // Check player bust or continue)
  void checkPlayerBust() async {
    if (gameUtils.isBust(playerHands[activeHandIndex])) {
      if (activeHandIndex == playerHands.length - 1) {
        if (playerHands.length == 1) { // dont have the dealer pull any cards since our one hand is already bust
          isPlayerTurn = false;
          isDealerTurn = true;
          notifyListeners();
          await Future.delayed(Duration(seconds: 1));
          determineOutcome();
        }
        endPlayerTurn();
      } else {
        moveToNextHand();
      }
    } 
  }

  void checkPlayerContinue() {
    if (activeHandIndex == playerHands.length - 1) {
      endPlayerTurn();
    } else {
      moveToNextHand();
    }
  }

  Future<void> endPlayerTurn() async {
    isPlayerTurn = false;
    isDealerTurn = true;
    activeHandIndex = 0;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    dealerPlays();
  }

  Future<void> dealerPlays() async {
    while (dealerHand.totalValue < (gameUtils.isSoft17(dealerHand) ? 18 : 17)) {
      dealCardToDealer();
      
      await Future.delayed(Duration(seconds: 1));
    }
    determineOutcome();
  }

  // Determine round outcome and update result
  void determineOutcome() { // potentially add bool surrendered
    for (int i = 0; i < playerHands.length; i++) {
      final playerHand = playerHands[i];
      final playerTotal = playerHand.totalValue;
      final dealerTotal = dealerHand.totalValue;
      String result;

      // if (surrendered) {
      //   result = "surrender";
      //   losses++;
      // } 
      if (playerTotal > 21) {
        result = 'bust';
        losses++;
      }
      else if (dealerTotal > 21 ||playerTotal > dealerTotal) {
        result = "win";
        wins++;
      } else if (dealerTotal > playerTotal) {
        result = "lose";
        losses++;
      } else {
        result = "push";
        ties++;
      }

      handsPlayed++;
      handResults.add(result);
    }
    isRoundOver = true;
    notifyListeners();
  }

  void resetRound() {
    playerHands = [Hand()];
    dealerHand.reset();
    activeHandIndex = 0;
    isDealerTurn = false;
    isPlayerTurn = true;
    //  surrendered = false;
    isRoundOver = false;
    feedback = null;
    handResults = [];

    notifyListeners();
    for (int i = 0; i < 2; i++) {
      dealCardToPlayer(activeHandIndex);
      dealCardToDealer();
    }
  }

  void resetGame() {
    runningCount = 0;
    isGameOver = false;
    correctActions = 0;
    incorrectActions = 0;
    wins = 0;
    losses = 0;
    ties = 0;
    handsPlayed = 0;
    notifyListeners(); 
    shuffleDeck();
  }

  void moveToNextHand() {
    activeHandIndex++;
    notifyListeners();
  }
}
