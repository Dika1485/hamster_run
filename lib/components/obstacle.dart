import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/hamster_run_game.dart';

enum ObstacleType { rock, cactus, acorn }

/// Rintangan yang bergerak dari kanan ke kiri layar.
class Obstacle extends PositionComponent with HasGameReference<HamsterRunGame> {
  final ObstacleType type;

  Obstacle({required Vector2 position, required this.type})
      : super(position: position, anchor: Anchor.bottomCenter) {
    switch (type) {
      case ObstacleType.cactus:
        size = Vector2(26, 52);
        break;
      case ObstacleType.rock:
        size = Vector2(42, 30);
        break;
      case ObstacleType.acorn:
        size = Vector2(30, 32);
        break;
    }
  }

  bool _counted = false;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(size: size * 0.85, position: size * 0.075));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isPlaying) return;

    position.x -= game.gameSpeed * dt;

    // tambah skor saat rintangan berhasil dilewati
    if (!_counted && position.x + size.x < game.hamster.position.x - game.hamster.size.x) {
      _counted = true;
      game.registerObstaclePassed();
    }

    if (position.x < -size.x - 20) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    switch (type) {
      case ObstacleType.rock:
        final paint = Paint()..color = const Color(0xFF9E9E9E);
        final darkPaint = Paint()..color = const Color(0xFF757575);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(10)),
          paint,
        );
        canvas.drawCircle(Offset(size.x * 0.3, size.y * 0.35), 4, darkPaint);
        canvas.drawCircle(Offset(size.x * 0.65, size.y * 0.6), 3, darkPaint);
        break;

      case ObstacleType.cactus:
        final paint = Paint()..color = const Color(0xFF66BB6A);
        final darkPaint = Paint()..color = const Color(0xFF4CAF50);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.x * 0.28, 0, size.x * 0.44, size.y),
            const Radius.circular(9),
          ),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, size.y * 0.28, size.x * 0.36, size.y * 0.26),
            const Radius.circular(7),
          ),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
                size.x * 0.64, size.y * 0.12, size.x * 0.36, size.y * 0.26),
            const Radius.circular(7),
          ),
          paint,
        );
        // duri-duri kecil
        for (double y = size.y * 0.15; y < size.y; y += 10) {
          canvas.drawCircle(Offset(size.x * 0.5, y), 1.4, darkPaint);
        }
        break;

      case ObstacleType.acorn:
        final shellPaint = Paint()..color = const Color(0xFFB98A63);
        final capPaint = Paint()..color = const Color(0xFF6D4C41);
        canvas.drawOval(
          Rect.fromLTWH(0, size.y * 0.28, size.x, size.y * 0.72),
          shellPaint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.x, size.y * 0.35),
            const Radius.circular(6),
          ),
          capPaint,
        );
        break;
    }
  }
}
