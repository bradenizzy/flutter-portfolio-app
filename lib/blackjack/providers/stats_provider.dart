// stats_provider.dart

import 'package:flutter/material.dart';

class StatsProvider extends ChangeNotifier {
  int correct = 0;
  int incorrect = 0;
  int wins = 0;
  int losses = 0;
  int ties = 0;
  int handsPlayed = 0;

  void updateWinLossTie(String outcome) {
    handsPlayed++;
    switch (outcome) {
      case 'win':
        wins++;
        break;
      case 'loss':
        losses++;
        break;
      case 'tie':
        ties++;
        break;
    }
    notifyListeners();
  }

  void updateCorrectIncorrect(bool isCorrect) {
    if (isCorrect) {
      correct++;
    } else {
      incorrect++;
    }
    notifyListeners();
  }

  void resetStats() {
    correct = 0;
    incorrect = 0;
    wins = 0;
    losses = 0;
    ties = 0;
    handsPlayed = 0;
    notifyListeners();
  }
}
