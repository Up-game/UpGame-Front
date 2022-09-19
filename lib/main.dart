import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'up_game.dart';

void main() {
  final game = UpGame();
  runApp(GameWidget(game: game));
}
