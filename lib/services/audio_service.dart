import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io' show Platform;
import 'dart:math' show Random;
import 'package:shinobi_self/models/character_path.dart';

/// Service for managing audio playback throughout the app
class AudioService {
  final AudioPlayer? _backgroundMusicPlayer;
  final AudioPlayer? _soundEffectsPlayer;
  bool _isMusicPaused = false;
  // Set volume higher to ensure it's audible during testing
  static const double defaultVolume = 0.7;
  static const double effectsVolume = 1.0; // Full volume for effects
  final bool _isSupported;
  final Random _random = Random();

  // Sound effect paths
  static const List<String> narutoSoundEffects = [
    'assets/sounds/believe-it.mp3',
    'assets/sounds/dattebayo.mp3',
    'assets/sounds/rasengan.mp3',
  ];
  
  static const List<String> sasukeSoundEffects = [
    'assets/sounds/ninetails.mp3',  // Using available files for Sasuke
    'assets/sounds/Good.mp3',       // since his specific sounds aren't available yet
    'assets/sounds/We-start.mp3',
  ];

  AudioService() : 
    // Initialize players only on supported platforms
    _isSupported = _checkPlatformSupport(),
    _backgroundMusicPlayer = _checkPlatformSupport() ? AudioPlayer() : null,
    _soundEffectsPlayer = _checkPlatformSupport() ? AudioPlayer() : null {
    if (_isSupported) {
      _initializeBackgroundMusic();
    } else {
      print("DEBUG: AudioService - Audio playback not supported on this platform");
    }
  }
  
  /// Check if the current platform supports audio playback
  static bool _checkPlatformSupport() {
    // Currently just_audio plugin may have issues with some desktop platforms
    // Add more platforms as needed
    return Platform.isAndroid || Platform.isIOS; 
  }

  /// Initialize the background music player
  Future<void> _initializeBackgroundMusic() async {
    if (!_isSupported || _backgroundMusicPlayer == null) return;
    
    try {
      // Set loop mode for continuous playback
      await _backgroundMusicPlayer!.setLoopMode(LoopMode.one);
      // Set volume to a lower level by default
      await _backgroundMusicPlayer!.setVolume(defaultVolume);
    } catch (e) {
      print('Error initializing background music: $e');
    }
  }

  /// Play background music from an asset path
  Future<void> playBackgroundMusic(String assetPath) async {
    if (!_isSupported || _backgroundMusicPlayer == null) {
      print("DEBUG: AudioService - Cannot play audio on this platform");
      return;
    }
    
    try {
      print("DEBUG: AudioService - playBackgroundMusic called with: $assetPath");
      // If the music was previously paused, resume it
      if (_isMusicPaused) {
        print("DEBUG: AudioService - Resuming paused music");
        await _backgroundMusicPlayer!.play();
        _isMusicPaused = false;
        return;
      }

      // Otherwise load the new asset and play
      print("DEBUG: AudioService - Loading asset: $assetPath");
      final duration = await _backgroundMusicPlayer!.setAsset(assetPath);
      print("DEBUG: AudioService - Asset loaded successfully. Duration: ${duration?.inSeconds ?? 'unknown'} seconds");
      
      await _backgroundMusicPlayer!.play();
      print("DEBUG: AudioService - Playback started");
    } catch (e) {
      print("DEBUG: AudioService - Error playing background music: $e");
    }
  }

  /// Play a sound effect based on character path
  Future<void> playCompletionSound(CharacterPath? characterPath) async {
    if (!_isSupported || _soundEffectsPlayer == null || characterPath == null) {
      return;
    }
    
    try {
      // Select the appropriate list of sound effects based on character path
      List<String> soundEffects;
      switch (characterPath) {
        case CharacterPath.naruto:
          soundEffects = narutoSoundEffects;
          break;
        case CharacterPath.sasuke:
          soundEffects = sasukeSoundEffects;
          break;
        default:
          // Default to no sound for other paths like Sakura (no sounds provided)
          return;
      }
      
      if (soundEffects.isEmpty) return;
      
      // Select a random sound effect from the list
      final randomIndex = _random.nextInt(soundEffects.length);
      final randomSound = soundEffects[randomIndex];
      
      print("DEBUG: AudioService - Playing completion sound: $randomSound");
      
      // Set volume for sound effect
      await _soundEffectsPlayer!.setVolume(effectsVolume);
      
      // Play the sound effect
      await _soundEffectsPlayer!.setAsset(randomSound);
      await _soundEffectsPlayer!.play();
    } catch (e) {
      print("DEBUG: AudioService - Error playing sound effect: $e");
    }
  }

  /// Pause the currently playing background music
  Future<void> pauseBackgroundMusic() async {
    if (!_isSupported || _backgroundMusicPlayer == null) return;
    
    try {
      if (_backgroundMusicPlayer!.playing) {
        await _backgroundMusicPlayer!.pause();
        _isMusicPaused = true;
      }
    } catch (e) {
      print('Error pausing background music: $e');
    }
  }

  /// Stop the background music completely
  Future<void> stopBackgroundMusic() async {
    if (!_isSupported || _backgroundMusicPlayer == null) return;
    
    try {
      await _backgroundMusicPlayer!.stop();
      _isMusicPaused = false;
    } catch (e) {
      print('Error stopping background music: $e');
    }
  }

  /// Set the volume level (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    if (!_isSupported || _backgroundMusicPlayer == null) return;
    
    try {
      await _backgroundMusicPlayer!.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  /// Toggle the background music between playing and paused
  Future<bool> toggleBackgroundMusic() async {
    if (!_isSupported || _backgroundMusicPlayer == null) return false;
    
    try {
      if (_backgroundMusicPlayer!.playing) {
        await pauseBackgroundMusic();
        return false;
      } else {
        if (_isMusicPaused) {
          await _backgroundMusicPlayer!.play();
          _isMusicPaused = false;
        } else {
          // If we haven't loaded any music yet, do nothing
          // This shouldn't happen in normal flow
          return false;
        }
        return true;
      }
    } catch (e) {
      print('Error toggling background music: $e');
      return false;
    }
  }

  /// Check if the background music is currently playing
  bool isPlaying() {
    if (!_isSupported || _backgroundMusicPlayer == null) return false;
    return _backgroundMusicPlayer!.playing;
  }

  /// Dispose the audio player resources
  void dispose() {
    if (_isSupported) {
      _backgroundMusicPlayer?.dispose();
      _soundEffectsPlayer?.dispose();
    }
  }
}

/// Provider for the audio service
final audioServiceProvider = Provider<AudioService>((ref) {
  final audioService = AudioService();
  
  // Dispose the audio service when the provider is disposed
  ref.onDispose(() {
    audioService.dispose();
  });
  
  return audioService;
});

/// Provider to track whether background music is currently playing
final backgroundMusicPlayingProvider = StateProvider<bool>((ref) => false);