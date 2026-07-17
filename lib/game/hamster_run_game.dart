import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/cloud.dart';
import '../components/ground.dart';
import '../components/hamster.dart';
import '../components/obstacle.dart';

class HamsterRunGame extends FlameGame with HasCollisionDetection {
  static const String highScoreKey = 'hamster_run_high_score';

  late Hamster hamster;
  late Ground ground;

  double gameSpeed = 300;
  double score = 0;
  int highScore = 0;
  bool isPlaying = false;

  final Random _random = Random();
  double _obstacleTimer = 0;
  double _nextObstacleIn = 1.4;

  @override
  Color backgroundColor() => const Color(0xFFBEE7F5);

  @override
  Future<void> onLoad() async {
    await _loadHighScore();

    // dekorasi awan
    add(Cloud(position: Vector2(60, 70), scale: 1.0, speed: 10));
    add(Cloud(position: Vector2(220, 40), scale: 0.7, speed: 16));
    add(Cloud(position: Vector2(340, 100), scale: 1.2, speed: 8));

    ground = Ground(position: Vector2(0, size.y - 44), width: size.x);
    add(ground);

    hamster = Hamster(position: Vector2(70, size.y - 44));
    hamster.groundY = size.y - 44;
    add(hamster);

    _beginRun();
  }

  void _beginRun() {
    isPlaying = true;
    score = 0;
    gameSpeed = 300;
    _obstacleTimer = 0;
    _nextObstacleIn = 1.4;
  }

  /// Dipanggil dari input (tap layar / spasi keyboard)
  void jump() {
    if (isPlaying) {
      hamster.jump();
    }
  }

  void registerObstaclePassed() {
    if (isPlaying) {
      score += 5;
    }
  }

  void onGameOver() {
    if (!isPlaying) return;
    isPlaying = false;

    final finalScore = score.toInt();
    if (finalScore > highScore) {
      highScore = finalScore;
      _saveHighScore();
    }
    overlays.add('GameOver');
  }

  void restart() {
    overlays.remove('GameOver');

    // bersihkan semua rintangan yang tersisa
    children.whereType<Obstacle>().toList().forEach((o) => o.removeFromParent());

    hamster.resetToGround();
    _beginRun();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isPlaying) return;

    // skor bertambah seiring jarak/waktu
    score += dt * 12;

    // tingkat kesulitan naik perlahan
    gameSpeed = 300 + score * 0.8;
    if (gameSpeed > 650) gameSpeed = 650;

    _obstacleTimer += dt;
    if (_obstacleTimer >= _nextObstacleIn) {
      _spawnObstacle();
      _obstacleTimer = 0;
      // interval spawn makin rapat seiring waktu, tapi ada batas minimum
      final minGap = 0.7;
      final maxGap = max(minGap + 0.2, 1.6 - score / 800);
      _nextObstacleIn = minGap + _random.nextDouble() * (maxGap - minGap);
    }
  }

  void _spawnObstacle() {
    final types = ObstacleType.values;
    final type = types[_random.nextInt(types.length)];
    final obstacle = Obstacle(
      position: Vector2(size.x + 40, size.y - 44),
      type: type,
    );
    add(obstacle);
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt(highScoreKey) ?? 0;
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(highScoreKey, highScore);
  }
}
