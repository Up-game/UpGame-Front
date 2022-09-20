import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import 'up_game.dart';

class GamePage extends Component with HasGameRef<UpGame> {
  late final SpriteAnimationComponent _characterSprite;

  @override
  Future<void>? onLoad() {
    final spritesheet = SpriteSheet(
      image: gameRef.images.fromCache('frog_run'),
      srcSize: Vector2.all(32.0),
    );

    final animation = spritesheet.createAnimation(row: 0, stepTime: 0.05);

    addAll([
      _characterSprite = SpriteAnimationComponent(
        animation: animation,
        position: Vector2(0, 0),
        size: Vector2.all(100.0),
      ),
    ]);

    return null;
  }
}

class Background extends Component {
  Background(this.color);
  final Color color;

  @override
  void render(Canvas canvas) {
    canvas.drawColor(color, BlendMode.srcATop);
  }
}
