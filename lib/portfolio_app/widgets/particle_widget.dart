// particle_widget.dart

import 'package:flutter/material.dart';
import '../models/particle_model.dart';

class ParticleWidget extends StatelessWidget {
  final Particle particle;
  final Animation<double> animation;

  ParticleWidget({required this.particle, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: (particle.position.dy + animation.value * particle.speed) % MediaQuery.of(context).size.height,
          left: particle.position.dx,
          child: Container(
            width: 2,
            height: 2,
            decoration: BoxDecoration(
              color: particle.color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
