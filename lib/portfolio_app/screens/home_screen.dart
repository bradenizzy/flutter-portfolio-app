// home_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/particle_util.dart';
import '../widgets/particle_widget.dart';
import '../models/particle_model.dart';
import '../widgets/to_app_button_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize _particles based on MediaQuery size
    _particles = List.generate(100, (_) => ParticleUtils.generateParticle(MediaQuery.of(context).size));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Generate a stack of ParticleWidgets
          ..._particles.map(
            (particle) => ParticleWidget(
              particle: particle,
              animation: Tween<double>(begin: 0, end: MediaQuery.of(context).size.height).animate(_controller),
            ),
          ),
          // Centered content for the homepage (e.g., title and button)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Izzy Appz Portfolio',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Explore our demo apps!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 24),
                ToAppButtonWidget(
                  appName: 'Blackjack Basic Strategy App',
                  routeName: '/blackjack',
                ),
                SizedBox(height: 16),
                ToAppButtonWidget(
                  appName: 'Instagram Education App',
                  routeName: '/instagram',
                ),
                SizedBox(height: 16),
                ToAppButtonWidget(
                  appName: 'Recipie App',
                  routeName: '/recipie',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
