import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'caklempong_view.dart';
import 'song_list_view.dart';

/// Home screen with navigation to Free Play and Tutorial modes.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                const Text(
                  'POCKET',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    color: AppColors.metallicGold,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                const Text(
                  'CAKLEMPONG',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    color: AppColors.metallicGold,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 16),
                // Decorative line
                Container(
                  width: 200,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.metallicGold,
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Traditional Malaysian Instrument',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 80),
                // Free Play Button
                _MenuButton(
                  icon: Icons.music_note,
                  label: 'FREE PLAY',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CaklempongView()),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Tutorial Button
                _MenuButton(
                  icon: Icons.school,
                  label: 'TUTORIAL',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SongListView()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Styled menu button with icon and label.
class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.metallicGold.withValues(alpha: 0.9),
              AppColors.darkBronze,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.metallicGold.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.lightGold.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.charcoal, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.charcoal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
