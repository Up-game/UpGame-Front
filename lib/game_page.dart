import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'up_game.dart';

class GamePage extends Component with HasGameRef<UpGame> {
  late final SpriteAnimationComponent _characterSprite;

  @override
  Future<void>? onLoad() {
    final spritesheet = SpriteSheet(
      image: gameRef.images.fromCache('frog_idle'),
      srcSize: Vector2.all(32.0),
    );

    final animation = spritesheet.createAnimation(row: 11, stepTime: 0.1);

    addAll([
      _characterSprite = SpriteAnimationComponent(
        animation: animation,
        position: Vector2(100, 100),
        size: Vector2.all(64.0),
      ),
    ]);

    return null;
  }
}
