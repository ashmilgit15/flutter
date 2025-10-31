import 'package:audioplayers/audioplayers.dart';

/// Service for managing ambient sounds and audio feedback
class AudioService {
  static final AudioPlayer _bgPlayer = AudioPlayer();
  static final AudioPlayer _sfxPlayer = AudioPlayer();

  static bool _soundEnabled = true;

  /// Initialize audio service
  static Future<void> initialize() async {
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.setVolume(0.3);
  }

  /// Enable/disable sound
  static void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    }
  }

  /// Play ambient background music
  static Future<void> playBackgroundMusic() async {
    if (!_soundEnabled) return;

    // Note: In production, you would have actual audio files
    // For now, this is a hook for when assets are added
    // await _bgPlayer.play(AssetSource('sounds/ambient_garden.mp3'));
  }

  /// Stop background music
  static Future<void> stopBackgroundMusic() async {
    await _bgPlayer.stop();
  }

  /// Play completion sound effect
  static Future<void> playCompletionSound() async {
    if (!_soundEnabled) return;

    // Hook for completion sound
    // await _sfxPlayer.play(AssetSource('sounds/plant_growth.mp3'));
  }

  /// Play watering sound (for completing habit)
  static Future<void> playWateringSound() async {
    if (!_soundEnabled) return;

    // Hook for watering sound
    // await _sfxPlayer.play(AssetSource('sounds/water.mp3'));
  }

  /// Play success chime
  static Future<void> playSuccessSound() async {
    if (!_soundEnabled) return;

    // Hook for success sound
    // await _sfxPlayer.play(AssetSource('sounds/success.mp3'));
  }

  /// Play gentle notification sound
  static Future<void> playNotificationSound() async {
    if (!_soundEnabled) return;

    // Hook for notification sound
    // await _sfxPlayer.play(AssetSource('sounds/gentle_bell.mp3'));
  }

  /// Dispose audio players
  static Future<void> dispose() async {
    await _bgPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
