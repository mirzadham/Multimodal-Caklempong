import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          width: double.infinity,
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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  // Title
                  Text(
                    'POCKET',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontStyle: FontStyle.italic,
                      color: AppColors.metallicGold,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                  Text(
                    'CAKLEMPONG',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontStyle: FontStyle.italic,
                      color: AppColors.metallicGold,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Decorative line
                  Container(
                    width: 180.w,
                    height: 2.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.metallicGold,
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Traditional Malaysian Instrument',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // Free Play Button
                  _MenuButton(
                    icon: Icons.music_note,
                    label: 'FREE PLAY',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CaklempongView(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
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
                  SizedBox(height: 20.h),
                ],
              ),
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
        width: 260.w,
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 32.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.metallicGold.withValues(alpha: 0.9),
              AppColors.darkBronze,
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.metallicGold.withValues(alpha: 0.3),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 8.r,
              offset: Offset(2.w, 4.h),
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
            Icon(icon, color: AppColors.charcoal, size: 28.sp),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                color: AppColors.charcoal,
                fontSize: 18.sp,
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
