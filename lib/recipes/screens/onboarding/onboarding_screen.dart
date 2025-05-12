// onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'title': 'Never touch your phone while cooking again.',
      'image': 'assets/onboarding/handsfree.png',
      'buttonText': 'See more',
    },
    {
      'title': 'Create or upload a recipe.',
      'image': 'assets/onboarding/upload_recipe.png',
      'buttonText': 'See more',
    },
    {
      'title': 'Notify your Chef Assistant.',
      'image': 'assets/onboarding/chefast.png',
      'buttonText': 'See more',
    },
    {
      'title': 'Put the phone down.',
      'image': 'assets/onboarding/letscook.png',
      'buttonText': "Let's Cook!",
    },
  ];

  void _nextPage() {
    if (_currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    //TODO: don't set the onboarding to true so we can continue testing
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    Navigator.of(context).pushReplacementNamed('/full_home');
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              final page = pages[index];

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (page['image'] != null)
                      Expanded(
                        child: Image.asset(
                          page['image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    SizedBox(height: 24),
                    Text(
                      page['title'] ?? '',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    if (page['buttonText'] != null)
                      ElevatedButton(
                        onPressed: isLast ? _finishOnboarding : _nextPage,
                        child: Text(page['buttonText']),
                      ),
                  ],
                ),
              );
            },
          ),

          // SKIP button
          if (!isLast)
            Positioned(
              top: 40,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _finishOnboarding,
                child: Text('Skip'),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pages.length,
            (i) => AnimatedContainer(
              margin: EdgeInsets.symmetric(horizontal: 4),
              duration: Duration(milliseconds: 200),
              width: _currentIndex == i ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == i ? Colors.pink : Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget build(BuildContext context) { 
  //   return Scaffold(
  //     body: PageView.builder(
  //       controller: _pageController,
  //       itemCount: pages.length,
  //       onPageChanged: (i) => setState(() => _currentIndex = i),
  //       itemBuilder: (context, index) {
  //         final page = pages[index];
  //         final isLast = index == pages.length - 1;

  //         return Padding(
  //           padding: const EdgeInsets.all(24.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               if (page['image'] != null)
  //                 Expanded(
  //                   child: Image.asset(
  //                     page['image'],
  //                     fit: BoxFit.contain,
  //                   ),
  //                 ),
  //               SizedBox(height: 24),
  //               Text(
  //                 page['title'] ?? '',
  //                 style: Theme.of(context).textTheme.headlineLarge,
  //                 textAlign: TextAlign.center,
  //               ),
  //               SizedBox(height: 32),
  //               if (page['buttonText'] != null)
  //                 ElevatedButton(
  //                   onPressed: isLast ? _finishOnboarding : _nextPage,
  //                   child: Text(page['buttonText']),
  //                 ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //     bottomNavigationBar: Padding(
  //       padding: const EdgeInsets.only(bottom: 16.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: List.generate(
  //           pages.length,
  //           (i) => AnimatedContainer(
  //             margin: EdgeInsets.symmetric(horizontal: 4),
  //             duration: Duration(milliseconds: 200),
  //             width: _currentIndex == i ? 12 : 8,
  //             height: 8,
  //             decoration: BoxDecoration(
  //               color: _currentIndex == i ? Colors.pink : Colors.grey[400],
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
