import 'dart:async';

import 'package:flutter/material.dart';

import '../game/hamster_run_game.dart';

class ScoreHud extends StatefulWidget {
  final HamsterRunGame game;
  const ScoreHud({super.key, required this.game});

  @override
  State<ScoreHud> createState() => _ScoreHudState();
}

class _ScoreHudState extends State<ScoreHud> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // refresh tampilan skor 10x per detik
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.game.score.toInt();
    final highScore = widget.game.highScore;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _pill(
              icon: Icons.directions_run_rounded,
              label: 'Score: $score',
              color: const Color(0xFFFF9F45),
            ),
            _pill(
              icon: Icons.emoji_events_rounded,
              label: 'Best: $highScore',
              color: const Color(0xFF7ED6A5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
