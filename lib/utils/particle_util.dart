// particle_util.dart

import 'dart:math';
import 'dart:ui';
import '../models/particle_model.dart';

class ParticleUtils {
  static final Random _random = Random();

  static Particle generateParticle(Size screenSize) {
    return Particle(
      position: Offset(
        _random.nextDouble() * screenSize.width,
        _random.nextDouble() * screenSize.height,
      ),
      color: _randomColor(),
      speed: 1 + _random.nextDouble() * 2, // Random speed between 1 and 3
    );
  }

  static Color _randomColor() {
    List<Color> colors = [
      Color(0xFFFF00FF), // Magenta
      Color(0xFF00FFFF), // Cyan
      Color(0xFFFFFF00), // Yellow
      Color(0xFF00FF00), // Green
      Color(0xFFFF0000), // Red
      Color(0xFF0000FF), // Blue
    ];
    return colors[_random.nextInt(colors.length)];
  }
}
