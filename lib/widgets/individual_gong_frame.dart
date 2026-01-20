import 'package:flutter/material.dart';

/// A reusable widget that simulates a wooden frame/rack compartment for a gong.
///
/// This provides the visual "hole" and frame structure that the gong sits in.
class IndividualGongFrame extends StatelessWidget {
  final Widget child;
  final double size;

  const IndividualGongFrame({
    super.key,
    required this.child,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 24, // Frame is slightly larger than the gong
      height: size + 24,
      decoration: BoxDecoration(
        color: const Color(0xFF2D1E1A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Deep shadow for the "hole" effect
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            offset: const Offset(2, 2),
            blurRadius: 3,
            // inset: true is not supported in standard Flutter BoxShadow,
            // so we simulate the recess with the inner Container below.
          ),
          // External shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3E2723), // Lighter wood top-left
            Color(0xFF1B1210), // Darker wood bottom-right
          ],
        ),
        border: Border.all(color: const Color(0xFF4E342E), width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inner "Recess" Shadow / Hole simulation
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
