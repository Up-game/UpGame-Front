import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:upgame/FixedHorizontalViewPort.dart';
import 'package:upgame/player/player_controller.dart';

import 'player/player.dart';
import 'up_game.dart';

const worldBoundary = Rect.fromLTRB(-700, -700, 700, 700);

class GamePage extends Component with HasGameRef<UpGame> {
  late final JoystickComponent _joystick;
  late final LocalPlayerController _playerController;
  late final Player _player;

  @override
  Future<void>? onLoad() async {
    _joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(gameRef.images.fromCache('joystick_position')),
        size: Vector2.all(70),
      ),
      background: SpriteComponent(
        sprite: Sprite(gameRef.images.fromCache('joystick_radius')),
        size: Vector2.all(100),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    _playerController = LocalPlayerController(_joystick);
    _player = Player(
      position: Vector2(0, 0),
      playerController: _playerController,
    );

    gameRef.camera.followVector2(Vector2(0, 0));
    //gameRef.camera.followComponent(_player, worldBounds: worldBoundary);

    gameRef.add(FpsTextComponent());
    add(Background(Colors.yellow));
    //add(ScreenHitbox());
    add(BottomBoundary());

    add(RightBoundary());
    add(LeftBoundary());

    add(_player);
    add(Player(position: Vector2(100, 100)));
    gameRef.add(_joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _playerController.update(dt);
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

class LeftBoundary extends PositionComponent
    with CollisionCallbacks, HasGameRef<UpGame> {
  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox(
        position: gameRef.camera
            .screenToWorld(Vector2(-gameRef.size.x / 2, -gameRef.size.y / 2)),
        size: Vector2(1, gameRef.size.y)));
  }
}

class RightBoundary extends PositionComponent
    with CollisionCallbacks, HasGameRef<UpGame> {
  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox(
        position: gameRef.camera
            .screenToWorld(Vector2(gameRef.size.x / 2, -gameRef.size.y / 2))
          ..sub(Vector2(1, 0)),
        size: Vector2(1, gameRef.size.y)));
  }
}

class BottomBoundary extends PositionComponent
    with CollisionCallbacks, HasGameRef<UpGame> {
  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox(
        position: gameRef.camera
            .screenToWorld(Vector2(-gameRef.size.x / 2, gameRef.size.y / 2))
          ..sub(Vector2(0, 1)),
        size: Vector2(gameRef.size.x, 1)));
  }
}
