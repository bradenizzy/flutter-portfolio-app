import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'portfolio_app/other/firebase_options.dart';
import 'portfolio_app/screens/home_screen.dart';
import 'portfolio_app/models/app_data.dart';
import 'portfolio_app/models/blackjack_data.dart';
import 'portfolio_app/models/trivia_data.dart';
import 'recipes/screens/recipe_home.dart';
import 'instagram/screens/insta_home.dart';
import 'blackjack/screens/blackjack_home.dart';
import 'blackjack/providers/game_provider.dart';
import 'blackjack/providers/stats_provider.dart';
import 'blackjack/screens/traditional_mode.dart';
import 'portfolio_app/other/themes.dart';
import 'blackjack/screens/blackjack_game_results.dart';
import 'blackjack/screens/blackjack_game_screen.dart';
import 'blackjack/screens/split_hands_mode.dart';
import 'blackjack/screens/soft_hands_mode.dart';
import 'blackjack/screens/double_down_mode.dart';
import 'recipes/screens/chef_chat_screen.dart';
import 'recipes/providers/recipe_provider.dart';
import 'dart:developer' as developer;
import 'package:flutter/rendering.dart';
import 'recipes/screens/sign_in_screen.dart';
import 'recipes/screens/complete_recipe_screen.dart';
import 'recipes/models/recipe.dart';


void main() async {
  //debugPaintPointersEnabled = true;
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
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
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
          '/recipe': (context) => RecipieHome(),
          '/bj_game': (context) => BJGameScreen(),
          '/traditional': (context) => TraditionalBlackjack(),
          '/split_hands': (context) => SplitHandsBlackjack(),
          '/soft_hands': (context) => SoftHandsBlackjack(),
          '/double_downs': (context) => DoubleDownBlackjack(),
          '/game_results': (context) => GameResultsScreen(),
          '/chef_chat': (context) => ChefChatScreen(),
          '/sign_in': (context) => SignInScreen(),
          '/complete_recipe': (context) => CompleteRecipeScreen(recipe: Recipe(
              id: "testing recipe ID",
              images: ["https://firebasestorage.googleapis.com/v0/b/flutter-portfolio-app-izzy.firebasestorage.app/o/recipes%2FhTY4sxdEjHHqT1ovr1Cd%2Fimages%2FFIuScrERXbbGVdEhLhfBxsAI74y2_1738438945277.jpg?alt=media&token=215846ab-1003-4449-922b-c17fd3e54f48"],
              title: "Title",
              prepTime: '10 minutes',
              cookTime: '15 minutes',
              restTime: '20 minutes',
              totalTime: '45 minutes',
              rating: 4.5,
              reviewsCount: 130,
              servings: 10,
              tags: ['tag1', 'tag2', 'tag3', 'tag1', 'tag2', 'tag3', 'tag1', 'tag2', 'tag3'],
              description: 'This is a description of the recipe',
              ingredients: [Ingredient(name: 'ingredient1', quantity: '1', unit: 'unit'), Ingredient(name: 'ingredient2', quantity: '2', unit: 'unit')],
              ingredientsFormat: 'US',
              equipment: ['equipment1', 'equipment2'],
              instructions: [InstructionSection(sectionTitle: 'instruction_title_1', steps: ['instruction1', 'instruction2', 'instruction3'])],
              notes: Notes(
                personalNotes: ['personal_notes_1'],
                proTips: ['pro_tip_1'],
                storage: ['storage_1'],
                makeAheadMethod: ['make_ahead_method_1'],
                reheatingLeftovers: ['reheating_leftovers_1'],
                other: ['other_1'],
              ),
              nutrition: Nutrition(
                calories: 100,
                fat: 10,
                protein: 10,
                carbs: 10,
              ),
              link: 'https://www.google.com',
              author: 'Unknown Author',
              source: 'Custom',
              isPublic: false,
            )
          ),
        },
    );
  }
}
