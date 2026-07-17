import 'package:flutter/material.dart';

import '../game/hamster_run_game.dart';

class GameOverOverlay extends StatelessWidget {
  final HamsterRunGame game;
  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final score = game.score.toInt();
    final highScore = game.highScore;
    final isNewHighScore = score >= highScore && score > 0;

    return Container(
      color: Colors.black.withOpacity(0.55),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF6E9),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFFFD59E), width: 4),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🐹', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 8),
            const Text(
              'Game Over!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF6D4C41),
              ),
            ),
            const SizedBox(height: 16),
            if (isNewHighScore)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '✨ New High Score! ✨',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6D4C41)),
                ),
              ),
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 20, color: Color(0xFF6D4C41)),
            ),
            const SizedBox(height: 4),
            Text(
              'High Score: $highScore',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF9E7B5B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: game.restart,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Play Again', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9F45),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
