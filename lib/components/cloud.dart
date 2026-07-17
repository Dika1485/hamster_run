import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Awan dekoratif yang melayang pelan di background (tidak mempengaruhi gameplay).
class Cloud extends PositionComponent {
  final double speed;

  Cloud({required Vector2 position, required double scale, this.speed = 12})
      : super(position: position, size: Vector2(70, 34) * scale);

  late double _screenWidth;

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    _screenWidth = gameSize.x;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
    if (position.x < -size.x) {
      position.x = _screenWidth + size.x;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.white.withOpacity(0.9);
    final w = size.x;
    final h = size.y;
    canvas.drawOval(Rect.fromLTWH(0, h * 0.35, w * 0.6, h * 0.55), paint);
    canvas.drawOval(Rect.fromLTWH(w * 0.3, h * 0.1, w * 0.55, h * 0.65), paint);
    canvas.drawOval(Rect.fromLTWH(w * 0.55, h * 0.3, w * 0.5, h * 0.55), paint);
  }
}
