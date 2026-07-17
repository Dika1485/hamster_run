# 🐹 Hamster Run

A simple endless runner built with **Flutter** + **Flame Engine**. All characters and obstacles are drawn via `Canvas` — no image assets needed.

## Features
- Jump mechanic (tap screen / Spacebar)
- Random obstacles (rock, cactus, acorn)
- Score system (increases over time + bonus per obstacle passed)
- Persistent high score via `SharedPreferences`
- Game Over screen with restart button
- Progressive difficulty (speed increases with score)
- Cute, colorful visual style

## Getting Started
```bash
flutter create hamster_run
cd hamster_run
# copy pubspec.yaml and lib/ from this repo, overwriting existing files
flutter pub get
flutter run
```

## Project Structure
```
lib/
├── main.dart                  # entry point, input handling
├── game/hamster_run_game.dart # core game logic
├── components/                # hamster, obstacle, ground, cloud
└── widgets/                   # score HUD, game over overlay
```

## Controls
Tap the screen (or press Space) to jump over obstacles.

## License
MIT — see [LICENSE](LICENSE).
