import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:upgame/player/player_controller.dart';

import 'player/player.dart';
import 'up_game.dart';

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

    gameRef.camera.followComponent(
      _player,
      worldBounds: const Rect.fromLTRB(-700, -700, 700, 700),
    );

    gameRef.add(FpsTextComponent());
    //add(ScreenHitbox());
    add(LeftBoundary());
    add(BottomBoundary());
    add(RightBoundary());
    add(_player);
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
        position: gameRef.camera.worldBounds!.topLeft.toVector2(),
        size: Vector2(1, gameRef.camera.worldBounds!.size.width)));
  }
}

class RightBoundary extends PositionComponent
    with CollisionCallbacks, HasGameRef<UpGame> {
  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox(
        position: gameRef.camera.worldBounds!.topRight.toVector2()
          ..sub(Vector2(1, 0)),
        size: Vector2(1, gameRef.camera.worldBounds!.size.width)));
  }
}

class BottomBoundary extends PositionComponent
    with CollisionCallbacks, HasGameRef<UpGame> {
  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox(
        position: gameRef.camera.worldBounds!.bottomLeft.toVector2()
          ..sub(Vector2(0, 1)),
        size: Vector2(gameRef.camera.worldBounds!.size.height, 1)));
  }
}
