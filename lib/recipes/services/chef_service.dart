// chef_service.dart
import 'package:audioplayers/audioplayers.dart';

class ChefService {
  final player = AudioPlayer();
  Future<void> startChatSession() async {
      await player.play(AssetSource('audio/chef.mp3'));
    }
  }

