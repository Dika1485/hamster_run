import 'package:flutter/material.dart';

class TapToStartOverlay extends StatelessWidget {
  const TapToStartOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: const Alignment(0, 0.35),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.6, end: 1.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
          builder: (context, value, child) => Opacity(opacity: value, child: child),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: const Text(
              '👆 Tap to Start',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D4C41),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
