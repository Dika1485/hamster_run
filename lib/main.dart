import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/hamster_run_game.dart';
import 'widgets/game_over_overlay.dart';
import 'widgets/score_hud.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const HamsterRunApp());
}

class HamsterRunApp extends StatelessWidget {
  const HamsterRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hamster Run',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final HamsterRunGame _game;

  @override
  void initState() {
    super.initState();
    _game = HamsterRunGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBEE7F5),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _game.jump,
        child: Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.space) {
              _game.jump();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: GameWidget<HamsterRunGame>(
            game: _game,
            overlayBuilderMap: {
              'HUD': (context, game) => ScoreHud(game: game),
              'GameOver': (context, game) => GameOverOverlay(game: game),
            },
            initialActiveOverlays: const ['HUD'],
          ),
        ),
      ),
    );
  }
}
