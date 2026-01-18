import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

import '../models/gong_model.dart';

/// ViewModel for the Caklempong instrument.
///
/// Handles all multimodal interaction logic:
/// - Audio playback via just_audio (with player pooling for multi-touch)
/// - Haptic feedback via vibration package
/// - Accelerometer-based tilt detection for muting
/// - State management for pressed gongs
class CaklempongViewModel extends ChangeNotifier {
  // ============================================
  // Configuration
  // ============================================

  /// Tilt angle threshold (in degrees) to trigger mute
  static const double _muteAngleThreshold = 45.0;

  /// Duration of haptic feedback in milliseconds
  static const int _hapticDuration = 50;

  /// Number of audio players per gong (for rapid re-triggering)
  static const int _playersPerGong = 2;

  // ============================================
  // State
  // ============================================

  /// List of gong models
  final List<GongModel> gongs = GongModel.defaultGongs;

  /// Set of currently pressed gong IDs
  final Set<int> _pressedGongs = {};

  /// Whether the instrument is muted (due to tilt)
  bool _isMuted = false;

  /// Current device pitch angle in degrees
  double _currentPitch = 0.0;

  /// Whether haptics are available on this device
  bool _hasVibrator = false;

  // ============================================
  // Audio Players
  // ============================================

  /// Pool of audio players for each gong
  /// Key: gong ID, Value: list of players for that gong
  final Map<int, List<AudioPlayer>> _audioPlayers = {};

  /// Current player index for each gong (round-robin)
  final Map<int, int> _currentPlayerIndex = {};

  /// Whether audio is initialized
  bool _isAudioInitialized = false;

  // ============================================
  // Sensor Subscription
  // ============================================

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // ============================================
  // Getters
  // ============================================

  /// Whether the instrument is currently muted
  bool get isMuted => _isMuted;

  /// Current pitch angle
  double get currentPitch => _currentPitch;

  /// Check if a specific gong is currently pressed
  bool isGongPressed(int id) => _pressedGongs.contains(id);

  /// Whether audio is ready to play
  bool get isReady => _isAudioInitialized;

  // ============================================
  // Initialization
  // ============================================

  /// Initialize all subsystems (audio, sensors, haptics)
  Future<void> initialize() async {
    await _initializeAudio();
    await _initializeHaptics();
    _initializeSensors();
  }

  Future<void> _initializeAudio() async {
    try {
      for (final gong in gongs) {
        final players = <AudioPlayer>[];

        for (int i = 0; i < _playersPerGong; i++) {
          final player = AudioPlayer();

          // Try to set the audio source
          // This will fail gracefully if asset doesn't exist
          try {
            await player.setAsset(gong.assetPath);
            await player.setVolume(1.0);
          } catch (e) {
            // Asset not found - this is expected for placeholders
            debugPrint('Audio asset not found: ${gong.assetPath}');
          }

          players.add(player);
        }

        _audioPlayers[gong.id] = players;
        _currentPlayerIndex[gong.id] = 0;
      }

      _isAudioInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to initialize audio: $e');
    }
  }

  Future<void> _initializeHaptics() async {
    try {
      _hasVibrator = await Vibration.hasVibrator() ?? false;
    } catch (e) {
      debugPrint('Failed to check vibrator: $e');
      _hasVibrator = false;
    }
  }

  void _initializeSensors() {
    _accelerometerSubscription = accelerometerEventStream().listen(
      _onAccelerometerEvent,
      onError: (error) {
        debugPrint('Accelerometer error: $error');
      },
    );
  }

  // ============================================
  // Sensor Handling
  // ============================================

  void _onAccelerometerEvent(AccelerometerEvent event) {
    // Calculate pitch angle from accelerometer data
    // Pitch = rotation around X axis (tilting forward/backward)
    // Using simplified calculation: atan2(z, y) gives tilt relative to gravity
    final double pitch = math.atan2(event.z, event.y) * (180 / math.pi);

    _currentPitch = pitch;

    // Check if phone is tilted forward beyond threshold
    // When phone is flat: pitch ≈ 90° (z pointing up)
    // When tilted forward: pitch decreases
    // We want to mute when tilted forward > 45° from horizontal
    final bool shouldMute = pitch.abs() < _muteAngleThreshold;

    if (shouldMute != _isMuted) {
      _isMuted = shouldMute;

      // If muting, stop all currently playing sounds
      if (_isMuted) {
        _stopAllGongs();
      }

      notifyListeners();
    }
  }

  // ============================================
  // Gong Interaction
  // ============================================

  /// Called when user starts pressing a gong
  void onGongPressed(int gongId) {
    if (_isMuted) return;

    _pressedGongs.add(gongId);
    _playGong(gongId);
    _triggerHaptic();
    notifyListeners();
  }

  /// Called when user releases a gong
  void onGongReleased(int gongId) {
    _pressedGongs.remove(gongId);
    notifyListeners();
  }

  /// Play the audio for a specific gong
  void _playGong(int gongId) async {
    if (!_isAudioInitialized) return;

    final players = _audioPlayers[gongId];
    if (players == null || players.isEmpty) return;

    // Round-robin through players for this gong
    final currentIndex = _currentPlayerIndex[gongId] ?? 0;
    final player = players[currentIndex];

    // Update index for next play
    _currentPlayerIndex[gongId] = (currentIndex + 1) % players.length;

    try {
      // Seek to start and play
      await player.seek(Duration.zero);
      await player.play();
    } catch (e) {
      debugPrint('Failed to play gong $gongId: $e');
    }
  }

  /// Stop all currently playing gongs
  void _stopAllGongs() {
    for (final players in _audioPlayers.values) {
      for (final player in players) {
        player.stop();
      }
    }
  }

  /// Trigger haptic feedback
  void _triggerHaptic() async {
    if (!_hasVibrator) return;

    try {
      await Vibration.vibrate(duration: _hapticDuration);
    } catch (e) {
      debugPrint('Failed to trigger haptic: $e');
    }
  }

  // ============================================
  // Cleanup
  // ============================================

  @override
  void dispose() {
    // Cancel sensor subscription
    _accelerometerSubscription?.cancel();

    // Dispose all audio players
    for (final players in _audioPlayers.values) {
      for (final player in players) {
        player.dispose();
      }
    }
    _audioPlayers.clear();

    super.dispose();
  }
}
