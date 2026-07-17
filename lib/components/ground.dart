import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/hamster_run_game.dart';

/// Tanah/lintasan yang terus scroll ke kiri memberi ilusi hamster berlari.
class Ground extends PositionComponent with HasGameReference<HamsterRunGame> {
  Ground({required Vector2 position, required double width})
      : super(position: position, size: Vector2(width, 44));

  double _scrollX = 0;
  static const double _stripeWidth = 26;
  static const double _stripeGap = 20;

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isPlaying) {
      _scrollX -= game.gameSpeed * dt;
      final period = _stripeWidth + _stripeGap;
      if (_scrollX <= -period) {
        _scrollX += period;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // lapisan tanah solid sampai dasar layar (biar tidak mengambang)
    final dirtPaint = Paint()..color = const Color(0xFF6D4C41);
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * 0.4, size.x, game.size.y - position.y),
      dirtPaint,
    );

    final basePaint = Paint()..color = const Color(0xFF8BC34A);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), basePaint);

    final topLine = Paint()..color = const Color(0xFF9CCC65);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 6), topLine);

    final stripePaint = Paint()..color = const Color(0xFF689F38);
    final period = _stripeWidth + _stripeGap;
    for (double x = _scrollX; x < size.x; x += period) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.y * 0.4, _stripeWidth, 8),
          const Radius.circular(4),
        ),
        stripePaint,
      );
    }
  }
}
