// deck_selector_drop_down.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class DeckSelectorDropdown extends StatefulWidget {
  @override
  _DeckSelectorDropdownState createState() => _DeckSelectorDropdownState();
}

class _DeckSelectorDropdownState extends State<DeckSelectorDropdown> {
  int selectedDecks = 1;

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    return FractionallySizedBox(
      widthFactor: 0.5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(8), 
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: selectedDecks,
            items: List.generate(8, (index) {
              int deckNumber = index + 1;
              return DropdownMenuItem(
                value: deckNumber,
                child: Center(
                  child: Text('$deckNumber'),
                ),
              );
            }),
            onChanged: (int? newValue) {
              setState(() {
                selectedDecks = newValue!;
              });
              gameProvider.numDecks = newValue!;
            },
            dropdownColor: Colors.white, 
            style: TextStyle(
              color: Colors.black, 
              fontSize: 16,       
            ),
            menuMaxHeight: 150,
          ),
        ),
      ),
    );
  }
}
