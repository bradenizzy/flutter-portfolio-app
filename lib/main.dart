import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'portfolio_app/other/firebase_options.dart';
import 'portfolio_app/screens/home_screen.dart';
import 'portfolio_app/models/app_data.dart';
import 'portfolio_app/models/blackjack_data.dart';
import 'portfolio_app/models/trivia_data.dart';
import 'recipies/screens/recipie_home.dart';
import 'instagram/screens/insta_home.dart';
import 'blackjack/screens/blackjack_home.dart';
import 'blackjack/providers/game_provider.dart';
import 'blackjack/providers/stats_provider.dart';
import 'blackjack/screens/traditional_blackjack.dart';
import 'portfolio_app/other/themes.dart';
import 'blackjack/screens/blackjack_game_results.dart';
import 'blackjack/screens/blackjack_game_screen.dart';
import 'blackjack/screens/split_hands_blackjack.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppData()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
        // ChangeNotifierProvider(create: (_) => BlackjackData()), 
        // ChangeNotifierProvider(create: (_) => TriviaData()),
      ],
      child: MyPortfolioApp(),
    ),
  );
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Portfolio App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/blackjack': (context) => BlackjackHome(),
          '/instagram': (context) => InstagramHome(),
          '/recipie': (context) => RecipieHome(),
          '/bj_game': (context) => BJGameScreen(),
          '/traditional': (context) => TraditionalBlackjack(),
          '/split_hands': (context) => SplitHandsBlackjack(),
          '/game_results': (context) => GameResultsScreen(),
        },
    );
  }
}


