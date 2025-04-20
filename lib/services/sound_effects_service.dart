import 'package:audioplayers/audioplayers.dart';
import 'package:shinobi_self/models/character_path.dart';

class SoundEffectsService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isInitialized = false;

  static final Map<CharacterPath, List<String>> _pathSounds = {
    CharacterPath.naruto: [
      'sounds/believe-it.mp3',
      'sounds/dattebayo.mp3',
      'sounds/rasengan.mp3',
    ],
    CharacterPath.sasuke: [
      'sounds/sasuke1.mp3',
      'sounds/sasuke2.mp3',
      'sounds/sasuke3.mp3',
    ],
    CharacterPath.sakura: [
      'sounds/sakura1.mp3',
      'sounds/sakura2.mp3',
      'sounds/sakura3.mp3',
    ],
  };

  static Future<void> playCompletionSound(CharacterPath path) async {
    try {
      if (!_isInitialized) {
        await _audioPlayer.setVolume(0.3);
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);
        _isInitialized = true;
      }

      final sounds = _pathSounds[path] ?? [];
      if (sounds.isNotEmpty) {
        final randomSound =
            sounds[(DateTime.now().millisecondsSinceEpoch % sounds.length)];
        await _audioPlayer.setSource(AssetSource(randomSound));
        await _audioPlayer.resume();
      }
    } catch (e) {
      print('Error playing completion sound: $e');
    }
  }

  static void dispose() {
    if (_isInitialized) {
      _audioPlayer.stop();
      _audioPlayer.dispose();
      _isInitialized = false;
    }
  }
}
