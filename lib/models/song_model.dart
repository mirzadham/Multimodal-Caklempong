/// A single note in a song sequence.
class SongNote {
  /// Which gong to hit (0-7)
  final int gongId;

  /// Time offset from song start in milliseconds
  final int timeMs;

  const SongNote({required this.gongId, required this.timeMs});
}

/// Data model representing a playable song tutorial.
class SongModel {
  /// Unique identifier
  final String id;

  /// Song title
  final String title;

  /// Difficulty level (1-3)
  final int difficulty;

  /// Sequence of notes to play
  final List<SongNote> notes;

  /// Tempo in BPM (for display purposes)
  final int bpm;

  const SongModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.notes,
    this.bpm = 100,
  });

  /// Duration of the song in milliseconds
  int get durationMs => notes.isEmpty ? 0 : notes.last.timeMs + 500;

  /// Available songs for tutorial mode
  /// Note mappings: 0=Do, 1=Re, 2=Mi, 3=Fa, 4=Sol, 5=La, 6=Ti, 7=Do'
  static const List<SongModel> availableSongs = [
    // Rasa Sayang - Simple Malaysian folk song
    SongModel(
      id: 'rasa_sayang',
      title: 'Rasa Sayang',
      difficulty: 1,
      bpm: 100,
      notes: [
        // "Ra-sa sa-yang, hey!"
        SongNote(gongId: 4, timeMs: 0), // Sol
        SongNote(gongId: 4, timeMs: 400), // Sol
        SongNote(gongId: 2, timeMs: 800), // Mi
        SongNote(gongId: 2, timeMs: 1200), // Mi
        SongNote(gongId: 0, timeMs: 1600), // Do
        // "Ra-sa sa-yang sa-yang hey"
        SongNote(gongId: 4, timeMs: 2400), // Sol
        SongNote(gongId: 4, timeMs: 2800), // Mi
        SongNote(gongId: 2, timeMs: 3200), // Mi
        SongNote(gongId: 2, timeMs: 3600), // Mi
        SongNote(gongId: 4, timeMs: 4000), // Sol
        SongNote(gongId: 0, timeMs: 4400), // Do
        // "Hey li-hat nona jauh"
        SongNote(gongId: 0, timeMs: 5200), // Do
        SongNote(gongId: 2, timeMs: 5600), // Mi
        SongNote(gongId: 4, timeMs: 6000), // Sol
        SongNote(gongId: 4, timeMs: 6400), // Sol
        SongNote(gongId: 2, timeMs: 6800), // Mi
      ],
    ),

    // Chan Mali Chan - Another Malaysian classic
    SongModel(
      id: 'chan_mali_chan',
      title: 'Chan Mali Chan',
      difficulty: 2,
      bpm: 120,
      notes: [
        // "Chan ma-li chan"
        SongNote(gongId: 0, timeMs: 0), // Do
        SongNote(gongId: 2, timeMs: 300), // Mi
        SongNote(gongId: 4, timeMs: 600), // Sol
        SongNote(gongId: 4, timeMs: 900), // Sol
        // "Chan ma-li chan"
        SongNote(gongId: 0, timeMs: 1500), // Do
        SongNote(gongId: 2, timeMs: 1800), // Mi
        SongNote(gongId: 4, timeMs: 2100), // Sol
        SongNote(gongId: 4, timeMs: 2400), // Sol
        // "Di ma-na dia ting-gal"
        SongNote(gongId: 7, timeMs: 3000), // Do'
        SongNote(gongId: 5, timeMs: 3300), // La
        SongNote(gongId: 4, timeMs: 3600), // Sol
        SongNote(gongId: 2, timeMs: 3900), // Mi
        SongNote(gongId: 4, timeMs: 4200), // Sol
        SongNote(gongId: 2, timeMs: 4500), // Mi
        SongNote(gongId: 0, timeMs: 4800), // Do
        // "Di pe-luk pulau pi-sang"
        SongNote(gongId: 0, timeMs: 5400), // Do
        SongNote(gongId: 2, timeMs: 5700), // Mi
        SongNote(gongId: 4, timeMs: 6000), // Sol
        SongNote(gongId: 4, timeMs: 6300), // Sol
        SongNote(gongId: 5, timeMs: 6600), // La
        SongNote(gongId: 4, timeMs: 6900), // Sol
        SongNote(gongId: 2, timeMs: 7200), // Mi
        SongNote(gongId: 0, timeMs: 7500), // Do
      ],
    ),

    // Burung Kakak Tua - Children's song
    SongModel(
      id: 'burung_kakak_tua',
      title: 'Burung Kakak Tua',
      difficulty: 1,
      bpm: 110,
      notes: [
        // "Bu-rung ka-kak tu-a"
        SongNote(gongId: 0, timeMs: 0), // Do
        SongNote(gongId: 0, timeMs: 350), // Do
        SongNote(gongId: 2, timeMs: 700), // Mi
        SongNote(gongId: 2, timeMs: 1050), // Mi
        SongNote(gongId: 4, timeMs: 1400), // Sol
        SongNote(gongId: 4, timeMs: 1750), // Sol
        // "Hing-gap di jen-de-la"
        SongNote(gongId: 4, timeMs: 2450), // Sol
        SongNote(gongId: 2, timeMs: 2800), // Mi
        SongNote(gongId: 0, timeMs: 3150), // Do
        SongNote(gongId: 2, timeMs: 3500), // Mi
        SongNote(gongId: 4, timeMs: 3850), // Sol
        SongNote(gongId: 4, timeMs: 4200), // Sol
        // "Ne-nek su-dah tu-a"
        SongNote(gongId: 7, timeMs: 4900), // Do'
        SongNote(gongId: 5, timeMs: 5250), // La
        SongNote(gongId: 4, timeMs: 5600), // Sol
        SongNote(gongId: 4, timeMs: 5950), // Sol
        SongNote(gongId: 2, timeMs: 6300), // Mi
        SongNote(gongId: 0, timeMs: 6650), // Do
        // "Gi-gi-nya ting-gal du-a"
        SongNote(gongId: 0, timeMs: 7350), // Do
        SongNote(gongId: 2, timeMs: 7700), // Mi
        SongNote(gongId: 4, timeMs: 8050), // Sol
        SongNote(gongId: 4, timeMs: 8400), // Sol
        SongNote(gongId: 2, timeMs: 8750), // Mi
        SongNote(gongId: 0, timeMs: 9100), // Do
      ],
    ),
  ];
}
