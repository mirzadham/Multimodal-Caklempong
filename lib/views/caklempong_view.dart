import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../viewmodels/caklempong_viewmodel.dart';
import '../widgets/gong_button.dart';
import '../widgets/individual_gong_frame.dart';

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
  late CaklempongViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CaklempongViewModel();

    // Lock to landscape for instrument play
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Initialize the ViewModel after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initialize();
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();

    // Restore portrait orientation when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.charcoal,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              _buildBackground(),
              _buildGongGrid(),
              _buildMuteOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('FREE PLAY'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
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
    return Stack(
      children: [
        // 1. Main Wooden Surface (The Table/Box)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4E342E), // Brown 800
                Color(0xFF3E2723), // Brown 900
                Color(0xFF210F0B), // Very Dark Brown
              ],
            ),
          ),
        ),

        // 2. Wood Grain Texture Effect
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
              tileMode: TileMode.repeated,
            ),
          ),
        ),

        // 3. The "Frame" Border
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF3E2723), // Dark wood border
              width: 12,
            ),
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6), // Vignette
              ],
              stops: const [0.6, 1.0],
            ),
          ),
        ),
      ],
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

            // Landscape mode: 4 gongs per row, 2 rows
            const gongsPerRow = 4;
            const rowCount = 2;
            const horizontalSpacing =
                8.0; // Reduced spacing for "connected" feel
            const verticalSpacing = 24.0;

            // Calculate gong size with padding
            // Calculate gong size with padding
            final availableWidth =
                screenWidth -
                48 -
                24; // 24px screen padding + 24px container padding
            final availableHeight = screenHeight - 60;

            // Size based on fitting 4 gongs per row (accounting for frame size)
            // Frame is gongSize + 24, so we need to account for that extra width
            final gongSizeByWidth =
                (availableWidth -
                    (gongsPerRow * 24) -
                    (gongsPerRow - 1) * horizontalSpacing) /
                gongsPerRow;

            final gongSizeByHeight =
                (availableHeight - (rowCount * 24) - verticalSpacing) /
                rowCount;

            final gongSize = gongSizeByWidth < gongSizeByHeight
                ? gongSizeByWidth
                : gongSizeByHeight;

            final clampedGongSize = gongSize.clamp(60.0, 110.0);

            // Split gongs into two rows
            final firstRow = viewModel.gongs.take(4).toList();
            final secondRow = viewModel.gongs.skip(4).toList();

            Widget buildGongRow(List gongs) {
              return Container(
                // Add a "Base Plate" behind the row to connect them visually
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1210), // Dark connector base
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: gongs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final gong = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < gongsPerRow - 1 ? horizontalSpacing : 0,
                      ),
                      child: IndividualGongFrame(
                        size: clampedGongSize,
                        child: GongButton(
                          gongId: gong.id,
                          note: gong.note,
                          isPressed: viewModel.isGongPressed(gong.id),
                          size: clampedGongSize,
                          onPressed: () => viewModel.onGongPressed(gong.id),
                          onReleased: () => viewModel.onGongReleased(gong.id),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildGongRow(firstRow),
                      SizedBox(height: verticalSpacing),
                      buildGongRow(secondRow),
                    ],
                  ),
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
