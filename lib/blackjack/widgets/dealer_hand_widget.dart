// dealer_hand_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/card_display_widget.dart';
import '../widgets/hidden_card_widget.dart';
import '../utils/blackjack_ui_util.dart';

class DealerHandWidget extends StatelessWidget {
  final BlackjackUiUtil ui_util = BlackjackUiUtil();
  @override
  Widget build(BuildContext context) {
    final dealerHand = context.watch<GameProvider>().dealerHand;
    final isDealerTurn = context.watch<GameProvider>().isDealerTurn;

    // Split dealer cards into rows of three
    final cardRows = ui_util.chunkList(dealerHand.cards, 3);

    return Column(
      children: [
        Text(
          'Dealer Hand:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Column(
          children: cardRows.map((cardRow) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: cardRow.map((card) {
                if (dealerHand.cards.indexOf(card) == 1 && !isDealerTurn) {
                  return HiddenCardWidget();
                } else {
                  return CardWidget(
                    card: card,
                    borderColor: Colors.red,
                  );
                }
              }).toList(),
            );
          }).toList(),
        ),
      ],
    );
  }
}


// class DealerHandWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final dealerHand = context.watch<GameProvider>().dealerHand;
//     final isDealerTurn = context.watch<GameProvider>().isDealerTurn;

//     return Column(
//       children: [
//         Text(
//           'Dealer Hand:',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(dealerHand.cards.length, (index) {
//               if (index == 1 && !isDealerTurn) {
//                 return HiddenCardWidget();
//               } else {
//                 return CardWidget(
//                   card: dealerHand.cards[index],
//                   borderColor: Colors.red,
//                 );
//               }
//             }),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // class DealerHandWidget extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final dealerHand = context.watch<GameProvider>().dealerHand;
// //     final isDealerTurn = context.watch<GameProvider>().isDealerTurn;
// //     return Column(
// //       children: [
// //         Text(
// //           'Dealer Hand:',
// //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //         ),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: List.generate(dealerHand.cards.length, (index) {
// //             if (index == 1 && !isDealerTurn) {
// //               return HiddenCardWidget();
// //             } else {
// //               return CardWidget(
// //                 card: dealerHand.cards[index],
// //                 borderColor: Colors.red,
// //               );
// //             }
// //           }),
// //         ),
// //       ],
// //     );
// //   }
// // }