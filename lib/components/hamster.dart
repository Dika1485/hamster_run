import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/hamster_run_game.dart';
import 'obstacle.dart';

/// Karakter hamster yang bisa lompat menghindari rintangan.
class Hamster extends PositionComponent
    with CollisionCallbacks, HasGameReference<HamsterRunGame> {
  Hamster({required Vector2 position})
      : super(
          position: position,
          size: Vector2(58, 46),
          anchor: Anchor.bottomCenter,
        );

  double velocityY = 0;
  final double gravity = 2000;
  final double jumpSpeed = 780;
  bool isJumping = false;

  /// posisi Y saat berada di tanah (di-set dari game)
  late double groundY = position.y;

  double _runCycle = 0;

  @override
  Future<void> onLoad() async {
    add(
      RectangleHitbox(
        size: Vector2(44, 36),
        position: Vector2(7, 8),
      ),
    );
  }

  void jump() {
    if (!isJumping) {
      velocityY = -jumpSpeed;
      isJumping = true;
    }
  }

  void resetToGround() {
    position.y = groundY;
    velocityY = 0;
    isJumping = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // physics lompat
    velocityY += gravity * dt;
    position.y += velocityY * dt;
    if (position.y >= groundY) {
      position.y = groundY;
      velocityY = 0;
      isJumping = false;
    }

    // animasi lari sederhana (bobbing) saat tidak lompat
    if (!isJumping && game.isPlaying) {
      _runCycle += dt * 14;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Obstacle && game.isPlaying && game.hasStarted) {
      game.onGameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    final bob = isJumping ? 0.0 : sin(_runCycle) * 2;
    final w = size.x;
    final h = size.y;

    final bodyPaint = Paint()..color = const Color(0xFFF5B971);
    final earOuter = Paint()..color = const Color(0xFFE0894A);
    final earInner = Paint()..color = const Color(0xFFFFC5C0);
    final white = Paint()..color = Colors.white;
    final black = Paint()..color = const Color(0xFF3B2A1F);
    final blush = Paint()..color = const Color(0xFFFF9AA2).withOpacity(0.75);
    final noseColor = Paint()..color = const Color(0xFFC97A63);
    final footPaint = Paint()..color = const Color(0xFFE0894A);

    canvas.save();
    canvas.translate(0, bob);

    // ekor
    canvas.drawCircle(Offset(-3, h * 0.55), 6, bodyPaint);

    // kaki (belakang)
    final legOffset = isJumping ? 0.0 : sin(_runCycle) * 6;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.28, h - 4 + legOffset), width: 14, height: 10),
      footPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.68, h - 4 - legOffset), width: 14, height: 10),
      footPaint,
    );

    // badan
    final bodyRect = Rect.fromLTWH(0, h * 0.18, w, h * 0.72);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(22)),
      bodyPaint,
    );

    // telinga
    canvas.drawCircle(Offset(w * 0.22, h * 0.14), 10, earOuter);
    canvas.drawCircle(Offset(w * 0.22, h * 0.14), 5.5, earInner);
    canvas.drawCircle(Offset(w * 0.78, h * 0.10), 10, earOuter);
    canvas.drawCircle(Offset(w * 0.78, h * 0.10), 5.5, earInner);

    // bercak wajah putih
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.78, h * 0.5), width: 26, height: 24),
      white,
    );

    // pipi gembil (blush)
    canvas.drawCircle(Offset(w * 0.62, h * 0.58), 6, blush);

    // mata
    canvas.drawCircle(Offset(w * 0.84, h * 0.46), 3.4, black);
    canvas.drawCircle(
        Offset(w * 0.84 - 1, h * 0.46 - 1), 1, white); // kilau mata

    // hidung
    canvas.drawCircle(Offset(w * 0.99, h * 0.52), 2.6, noseColor);

    canvas.restore();
  }
}
