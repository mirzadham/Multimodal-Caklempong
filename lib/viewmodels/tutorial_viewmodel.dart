import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/song_model.dart';

/// ViewModel for the song tutorial mode.
///
/// Manages:
/// - Song playback timing and note progression
/// - Highlighted gong tracking
/// - Score and hit detection
class TutorialViewModel extends ChangeNotifier {
  // ============================================
  // Configuration
  // ============================================

  /// Time window (ms) for a hit to count as "correct"
  static const int _hitWindowMs = 400;

  /// Time before the note to start highlighting (ms)
  static const int _highlightLeadMs = 600;

  // ============================================
  // State
  // ============================================

  /// The current song being played
  final SongModel song;

  /// Current note index in the song
  int _currentNoteIndex = 0;

  /// Whether the tutorial is actively playing
  bool _isPlaying = false;

  /// Whether the tutorial is paused
  bool _isPaused = false;

  /// Song start timestamp
  DateTime? _startTime;

  /// Total score
  int _score = 0;

  /// Number of hits
  int _hits = 0;

  /// Number of misses
  int _misses = 0;

  /// Currently highlighted gong ID (-1 if none)
  int _highlightedGongId = -1;

  /// Whether the song has completed
  bool _isComplete = false;

  /// Timer for updating state
  Timer? _updateTimer;

  // ============================================
  // Getters
  // ============================================

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  bool get isComplete => _isComplete;
  int get currentNoteIndex => _currentNoteIndex;
  int get totalNotes => song.notes.length;
  int get score => _score;
  int get hits => _hits;
  int get misses => _misses;
  int get highlightedGongId => _highlightedGongId;

  /// Progress through the song (0.0 to 1.0)
  double get progress {
    if (song.notes.isEmpty) return 0.0;
    return _currentNoteIndex / song.notes.length;
  }

  /// Accuracy percentage
  double get accuracy {
    final total = _hits + _misses;
    if (total == 0) return 100.0;
    return (_hits / total) * 100;
  }

  /// Current elapsed time in milliseconds
  int get elapsedMs {
    if (_startTime == null) return 0;
    return DateTime.now().difference(_startTime!).inMilliseconds;
  }

  // ============================================
  // Constructor
  // ============================================

  TutorialViewModel({required this.song});

  // ============================================
  // Playback Control
  // ============================================

  /// Start the tutorial
  void start() {
    if (_isPlaying) return;

    _isPlaying = true;
    _isPaused = false;
    _isComplete = false;
    _currentNoteIndex = 0;
    _score = 0;
    _hits = 0;
    _misses = 0;
    _startTime = DateTime.now();
    _highlightedGongId = -1;

    // Start update loop
    _updateTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => _update(),
    );

    notifyListeners();
  }

  /// Pause the tutorial
  void pause() {
    if (!_isPlaying || _isPaused) return;
    _isPaused = true;
    _updateTimer?.cancel();
    notifyListeners();
  }

  /// Resume the tutorial
  void resume() {
    if (!_isPaused) return;
    _isPaused = false;

    // Adjust start time to account for pause
    _updateTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => _update(),
    );

    notifyListeners();
  }

  /// Stop and reset the tutorial
  void stop() {
    _isPlaying = false;
    _isPaused = false;
    _updateTimer?.cancel();
    _highlightedGongId = -1;
    notifyListeners();
  }

  // ============================================
  // Game Loop
  // ============================================

  void _update() {
    if (_isPaused || !_isPlaying) return;

    final elapsed = elapsedMs;

    // Check if we've completed the song
    if (_currentNoteIndex >= song.notes.length) {
      _complete();
      return;
    }

    final currentNote = song.notes[_currentNoteIndex];
    final noteTime = currentNote.timeMs;

    // Start highlighting before the note
    if (elapsed >= noteTime - _highlightLeadMs &&
        elapsed < noteTime + _hitWindowMs) {
      if (_highlightedGongId != currentNote.gongId) {
        _highlightedGongId = currentNote.gongId;
        notifyListeners();
      }
    }

    // Check if note was missed (past the hit window)
    if (elapsed > noteTime + _hitWindowMs) {
      _misses++;
      _highlightedGongId = -1;
      _currentNoteIndex++;
      notifyListeners();
    }
  }

  void _complete() {
    _isPlaying = false;
    _isComplete = true;
    _updateTimer?.cancel();
    _highlightedGongId = -1;
    notifyListeners();
  }

  // ============================================
  // Hit Detection
  // ============================================

  /// Called when a gong is hit during tutorial
  /// Returns true if it was the correct gong
  bool onGongHit(int gongId) {
    if (!_isPlaying || _isPaused || _isComplete) return false;
    if (_currentNoteIndex >= song.notes.length) return false;

    final currentNote = song.notes[_currentNoteIndex];
    final elapsed = elapsedMs;
    final noteTime = currentNote.timeMs;

    // Check if within hit window
    final timeDiff = (elapsed - noteTime).abs();
    if (timeDiff <= _hitWindowMs && gongId == currentNote.gongId) {
      // Correct hit!
      _hits++;

      // Score based on timing accuracy
      final accuracyBonus = (1.0 - (timeDiff / _hitWindowMs)) * 50;
      _score += 100 + accuracyBonus.round();

      _highlightedGongId = -1;
      _currentNoteIndex++;
      notifyListeners();
      return true;
    }

    return false;
  }

  // ============================================
  // Cleanup
  // ============================================

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}
