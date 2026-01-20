import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/song_model.dart';
import '../theme/app_colors.dart';
import '../viewmodels/caklempong_viewmodel.dart';
import '../viewmodels/tutorial_viewmodel.dart';
import '../widgets/gong_button.dart';
import '../widgets/individual_gong_frame.dart';

class TutorialView extends StatefulWidget {
  final SongModel song;

  const TutorialView({super.key, required this.song});

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  late CaklempongViewModel _caklempongVM;
  late TutorialViewModel _tutorialVM;

  @override
  void initState() {
    super.initState();
    _caklempongVM = CaklempongViewModel();
    _tutorialVM = TutorialViewModel(song: widget.song);

    // Lock to landscape for instrument play
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _caklempongVM.initialize();
    });
  }

  @override
  void dispose() {
    _caklempongVM.dispose();
    _tutorialVM.dispose();

    // Restore portrait orientation when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _caklempongVM),
        ChangeNotifierProvider.value(value: _tutorialVM),
      ],
      child: Scaffold(
        backgroundColor: AppColors.charcoal,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              _buildBackground(),
              Column(
                children: [
                  Expanded(child: _buildGongGrid()),
                  _buildControls(),
                ],
              ),
              _buildScoreDisplay(),
              _buildAccuracyDisplay(),
              _buildCompletionOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(widget.song.title),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Consumer<TutorialViewModel>(
          builder: (context, vm, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PROGRESS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '${vm.currentNoteIndex}/${vm.totalNotes}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildScoreDisplay() {
    return Consumer<TutorialViewModel>(
      builder: (context, vm, _) {
        return Positioned(
          top: 80,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SCORE',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${vm.score}',
                style: const TextStyle(
                  color: AppColors.metallicGold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccuracyDisplay() {
    return Consumer<TutorialViewModel>(
      builder: (context, vm, _) {
        return Positioned(
          bottom: 80,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'ACCURACY',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${vm.accuracy.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: vm.accuracy >= 80
                      ? Colors.green
                      : vm.accuracy >= 50
                      ? Colors.orange
                      : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground() {
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
    return Consumer2<CaklempongViewModel, TutorialViewModel>(
      builder: (context, caklempongVM, tutorialVM, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Calculate optimal gong size based on screen
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            // Landscape mode: 4 gongs per row, 2 rows
            const gongsPerRow = 4;
            const rowCount = 2;
            const horizontalSpacing = 8.0;
            const verticalSpacing = 24.0;

            // Calculate gong size with padding
            final availableWidth =
                screenWidth -
                48 -
                24; // 24px screen padding + 24px container padding
            final availableHeight = screenHeight - 60;

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

            final clampedGongSize = gongSize.clamp(40.0, 110.0);

            final firstRow = caklempongVM.gongs.take(4).toList();
            final secondRow = caklempongVM.gongs.skip(4).toList();

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
                    final isHighlighted =
                        tutorialVM.highlightedGongId == gong.id;

                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < gongsPerRow - 1 ? horizontalSpacing : 0,
                      ),
                      child: IndividualGongFrame(
                        size: clampedGongSize,
                        child: GongButton(
                          gongId: gong.id,
                          note: gong.note,
                          isPressed: caklempongVM.isGongPressed(gong.id),
                          isHighlighted: isHighlighted,
                          size: clampedGongSize,
                          onPressed: () {
                            caklempongVM.onGongPressed(gong.id);
                            tutorialVM.onGongHit(gong.id);
                          },
                          onReleased: () =>
                              caklempongVM.onGongReleased(gong.id),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildGongRow(firstRow),
                    SizedBox(height: verticalSpacing),
                    buildGongRow(secondRow),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildControls() {
    return Consumer<TutorialViewModel>(
      builder: (context, vm, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!vm.isPlaying && !vm.isComplete)
                _ControlButton(
                  icon: Icons.play_arrow,
                  label: 'START',
                  onTap: () => vm.start(),
                )
              else if (vm.isPlaying && !vm.isPaused)
                _ControlButton(
                  icon: Icons.pause,
                  label: 'PAUSE',
                  onTap: () => vm.pause(),
                )
              else if (vm.isPaused)
                _ControlButton(
                  icon: Icons.play_arrow,
                  label: 'RESUME',
                  onTap: () => vm.resume(),
                ),
              if (vm.isPlaying || vm.isPaused) ...[
                const SizedBox(width: 20),
                _ControlButton(
                  icon: Icons.stop,
                  label: 'STOP',
                  onTap: () => vm.stop(),
                  isSecondary: true,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompletionOverlay() {
    return Consumer<TutorialViewModel>(
      builder: (context, vm, _) {
        if (!vm.isComplete) return const SizedBox.shrink();

        return Container(
          color: AppColors.black.withValues(alpha: 0.85),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.celebration,
                    size: 60,
                    color: AppColors.metallicGold,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'SONG COMPLETE!',
                    style: TextStyle(
                      color: AppColors.metallicGold,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats
                  _StatRow(label: 'Score', value: '${vm.score}'),
                  _StatRow(label: 'Hits', value: '${vm.hits}/${vm.totalNotes}'),
                  _StatRow(
                    label: 'Accuracy',
                    value: '${vm.accuracy.toStringAsFixed(1)}%',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ControlButton(
                        icon: Icons.replay,
                        label: 'RETRY',
                        onTap: () => vm.start(),
                      ),
                      const SizedBox(width: 12),
                      _ControlButton(
                        icon: Icons.home,
                        label: 'MENU',
                        onTap: () => Navigator.pop(context),
                        isSecondary: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSecondary;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSecondary
              ? null
              : LinearGradient(
                  colors: [
                    AppColors.metallicGold.withValues(alpha: 0.9),
                    AppColors.darkBronze,
                  ],
                ),
          color: isSecondary ? AppColors.charcoalLight : null,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSecondary
                ? AppColors.textSecondary
                : AppColors.lightGold.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSecondary ? AppColors.textSecondary : AppColors.charcoal,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSecondary
                    ? AppColors.textSecondary
                    : AppColors.charcoal,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
