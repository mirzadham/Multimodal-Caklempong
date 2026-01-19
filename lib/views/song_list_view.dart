import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            padding: EdgeInsets.all(24.w),
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
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.charcoalLight.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.metallicGold.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            // Music icon
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                gradient: AppColors.gongGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.metallicGold.withValues(alpha: 0.3),
                    blurRadius: 8.r,
                  ),
                ],
              ),
              child: Icon(
                Icons.music_note,
                color: AppColors.charcoal,
                size: 28.sp,
              ),
            ),
            SizedBox(width: 20.w),
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      _buildDifficultyIndicator(),
                      SizedBox(width: 16.w),
                      Text(
                        '${song.notes.length} notes',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
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
              size: 40.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
