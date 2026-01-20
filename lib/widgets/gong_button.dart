import 'package:flutter/material.dart';

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
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: _buildShadows(),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Real Gong Image
              Image.asset(
                'assets/images/gong.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),

              // Pressed State Overlay (Darken)
              if (widget.isPressed)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                ),

              // Tutorial Highlight Overlay
              if (widget.isHighlighted)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _buildShadows() {
    return [
      // Deep Drop Shadow
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.6),
        blurRadius: widget.isPressed ? 6 : 12,
        spreadRadius: 0,
        offset: Offset(0, widget.isPressed ? 4 : 8),
      ),
    ];
  }
}
