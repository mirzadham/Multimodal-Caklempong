/// Data model representing a single Caklempong gong.
///
/// The Caklempong traditionally consists of 8 gongs (bonang-style)
/// arranged to play a pentatonic scale.
class GongModel {
  /// Unique identifier for the gong (0-7 for 8 gongs)
  final int id;

  /// Note name displayed on the gong (e.g., "Do", "Re", "Mi")
  final String note;

  /// Path to the audio asset for this gong's sound
  final String assetPath;

  /// Frequency hint for the note (optional, for display purposes)
  final double? frequency;

  const GongModel({
    required this.id,
    required this.note,
    required this.assetPath,
    this.frequency,
  });

  /// Default set of 8 gongs matching traditional Caklempong
  static const List<GongModel> defaultGongs = [
    GongModel(id: 0, note: 'Do', assetPath: 'assets/audio/gong_1.wav'),
    GongModel(id: 1, note: 'Re', assetPath: 'assets/audio/gong_2.wav'),
    GongModel(id: 2, note: 'Mi', assetPath: 'assets/audio/gong_3.wav'),
    GongModel(id: 3, note: 'Fa', assetPath: 'assets/audio/gong_4.wav'),
    GongModel(id: 4, note: 'Sol', assetPath: 'assets/audio/gong_5.wav'),
    GongModel(id: 5, note: 'La', assetPath: 'assets/audio/gong_6.wav'),
    GongModel(id: 6, note: 'Ti', assetPath: 'assets/audio/gong_7.wav'),
    GongModel(id: 7, note: "Do'", assetPath: 'assets/audio/gong_8.wav'),
  ];

  @override
  String toString() => 'GongModel(id: $id, note: $note)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GongModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
