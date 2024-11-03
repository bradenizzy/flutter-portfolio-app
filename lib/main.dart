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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppData()),
        ChangeNotifierProvider(create: (_) => BlackjackData()), 
        ChangeNotifierProvider(create: (_) => TriviaData()),
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(),
        routes: {
          '/blackjack': (context) => BlackjackHome(),
          '/instagram': (context) => InstagramHome(),
          '/recipie': (context) => RecipieHome(),
        },
    );
  }
}


