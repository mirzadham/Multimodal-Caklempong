import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A single Caklempong gong button widget.
///
/// Features skeuomorphic 3D metallic gold appearance using:
/// - RadialGradient for convex metallic look
/// - Multiple BoxShadows for depth
/// - Scale animation on tap
/// - Glow effect when pressed
class GongButton extends StatefulWidget {
  /// Unique identifier for this gong
  final int gongId;

  /// Note label displayed on the gong
  final String note;

  /// Whether this gong is currently pressed
  final bool isPressed;

  /// Whether this gong is highlighted (tutorial mode)
  final bool isHighlighted;

  /// Callback when gong is pressed down
  final VoidCallback? onPressed;

  /// Callback when gong is released
  final VoidCallback? onReleased;

  /// Size of the gong (diameter)
  final double size;

  const GongButton({
    super.key,
    required this.gongId,
    required this.note,
    this.isPressed = false,
    this.isHighlighted = false,
    this.onPressed,
    this.onReleased,
    this.size = 100,
  });

  @override
  State<GongButton> createState() => _GongButtonState();
}

class _GongButtonState extends State<GongButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92, // Shrink to 92% when pressed
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(GongButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate based on pressed state
    if (widget.isPressed && !oldWidget.isPressed) {
      _controller.forward();
    } else if (!widget.isPressed && oldWidget.isPressed) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => widget.onPressed?.call(),
      onTapUp: (_) => widget.onReleased?.call(),
      onTapCancel: () => widget.onReleased?.call(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: widget.isPressed
                ? AppColors.gongActiveGradient
                : AppColors.gongGradient,
            boxShadow: _buildShadows(),
            border: Border.all(
              color: widget.isHighlighted
                  ? Colors.white
                  : widget.isPressed
                  ? AppColors.maroon
                  : AppColors.darkBronze,
              width: widget.isHighlighted ? 4 : 3,
            ),
          ),
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }

  List<BoxShadow> _buildShadows() {
    return [
      // Outer shadow for depth
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: widget.isPressed ? 8 : 15,
        spreadRadius: widget.isPressed ? 1 : 2,
        offset: Offset(widget.isPressed ? 2 : 4, widget.isPressed ? 2 : 4),
      ),
      // Inner highlight (simulated with positioned gradient)
      BoxShadow(
        color: AppColors.lightGold.withValues(
          alpha: widget.isPressed ? 0.2 : 0.3,
        ),
        blurRadius: 10,
        spreadRadius: -5,
        offset: const Offset(-3, -3),
      ),
      // Glow effect when pressed
      if (widget.isPressed)
        BoxShadow(
          color: AppColors.metallicGold.withValues(alpha: 0.6),
          blurRadius: 20,
          spreadRadius: 3,
        ),
      // Highlight glow for tutorial mode
      if (widget.isHighlighted)
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.8),
          blurRadius: 25,
          spreadRadius: 5,
        ),
    ];
  }
}
