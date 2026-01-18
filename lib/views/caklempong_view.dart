import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../viewmodels/caklempong_viewmodel.dart';
import '../widgets/gong_button.dart';

/// Main view for the Caklempong instrument.
///
/// Displays a grid of 8 gong buttons with:
/// - Dark charcoal background
/// - Responsive grid layout
/// - Mute indicator overlay when device is tilted
class CaklempongView extends StatefulWidget {
  const CaklempongView({super.key});

  @override
  State<CaklempongView> createState() => _CaklempongViewState();
}

class _CaklempongViewState extends State<CaklempongView> {
  @override
  void initState() {
    super.initState();

    // Initialize the ViewModel after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CaklempongViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [_buildBackground(), _buildGongGrid(), _buildMuteOverlay()],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('POCKET CAKLEMPONG'),
      actions: [
        Consumer<CaklempongViewModel>(
          builder: (context, vm, _) {
            if (vm.isMuted) {
              return const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.volume_off, color: AppColors.maroon),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildBackground() {
    // Subtle radial gradient background for depth
    return Container(
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
    );
  }

  Widget _buildGongGrid() {
    return Consumer<CaklempongViewModel>(
      builder: (context, viewModel, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Calculate optimal gong size based on screen
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            // 4 gongs per row, 2 rows
            const crossAxisCount = 4;
            const mainAxisCount = 2;

            // Calculate gong size with padding
            final availableWidth = screenWidth - 40; // 20px padding each side
            final availableHeight =
                screenHeight - 60; // Extra padding for spacing

            final gongSizeByWidth = availableWidth / crossAxisCount - 16;
            final gongSizeByHeight = availableHeight / mainAxisCount - 32;

            final gongSize = gongSizeByWidth < gongSizeByHeight
                ? gongSizeByWidth
                : gongSizeByHeight;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: viewModel.gongs.map((gong) {
                    return GongButton(
                      gongId: gong.id,
                      note: gong.note,
                      isPressed: viewModel.isGongPressed(gong.id),
                      size: gongSize.clamp(60, 120),
                      onPressed: () => viewModel.onGongPressed(gong.id),
                      onReleased: () => viewModel.onGongReleased(gong.id),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMuteOverlay() {
    return Consumer<CaklempongViewModel>(
      builder: (context, viewModel, _) {
        return AnimatedOpacity(
          opacity: viewModel.isMuted ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: IgnorePointer(
            ignoring: !viewModel.isMuted,
            child: Container(
              color: AppColors.black.withValues(alpha: 0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.pan_tool,
                      size: 80,
                      color: AppColors.maroon.withValues(alpha: 0.8),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'MUTED',
                      style: TextStyle(
                        color: AppColors.textPrimary.withValues(alpha: 0.8),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tilt device upright to play',
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
