import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../theme/app_colors.dart';
import 'tutorial_view.dart';

/// Song selection screen for tutorial mode.
class SongListView extends StatelessWidget {
  const SongListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      appBar: AppBar(
        title: const Text('SELECT A SONG'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                AppColors.charcoalLight,
                AppColors.charcoal,
                AppColors.black,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: SongModel.availableSongs.length,
            itemBuilder: (context, index) {
              final song = SongModel.availableSongs[index];
              return _SongCard(song: song);
            },
          ),
        ),
      ),
    );
  }
}

/// Card displaying song info with tap to start tutorial.
class _SongCard extends StatelessWidget {
  final SongModel song;

  const _SongCard({required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TutorialView(song: song)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.charcoalLight.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.metallicGold.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Music icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.gongGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.metallicGold.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note,
                color: AppColors.charcoal,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildDifficultyIndicator(),
                      const SizedBox(width: 16),
                      Text(
                        '${song.notes.length} notes',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Play arrow
            Icon(
              Icons.play_circle_fill,
              color: AppColors.metallicGold,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator() {
    final labels = ['Easy', 'Medium', 'Hard'];
    final colors = [Colors.green, Colors.orange, Colors.red];
    final label = labels[song.difficulty - 1];
    final color = colors[song.difficulty - 1];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
