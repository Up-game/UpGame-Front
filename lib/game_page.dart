import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:upgame/player/player_controller.dart';
import 'package:upgame/tile.dart';

import 'player/player.dart';
import 'up_game.dart';

const worldBoundary = Rect.fromLTRB(-400, -800, 400, 0);

class GamePage extends Component with HasGameRef<UpGame> {
  late final JoystickComponent _joystick;
  late final LocalPlayerController _playerController;
  late final Player _player;
  late final UpGameWorld upGameWorld;

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
      position: Vector2(50, -750),
      playerController: _playerController,
    );

    gameRef.camera.followVector2(
      Vector2(0, -400 + 400 - gameRef.size.y / 2),
    );

    //gameRef.camera.followComponent(_player, worldBounds: worldBoundary);

    gameRef.add(FpsTextComponent());
    add(Background(Colors.yellow));
    add(MyParallaxComponent());
    // add(BottomBoundary());
    // add(RightBoundary());
    // add(LeftBoundary());
    add(upGameWorld = UpGameWorld());
    add(_player);
    gameRef.add(_joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _playerController.update(dt);
  }
}

class UpGameWorld extends Component {
  @override
  Future<void>? onLoad() {
    children.register<Tile>();
    add(Tile('grass', size: Vector2(100, 100), position: Vector2(0, -500)));
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
  final double _height = 800;
  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox(
      position: Vector2(-400, -_height),
      size: Vector2(1, _height),
    ));
  }
}

class RightBoundary extends PositionComponent
    with CollisionCallbacks, HasGameRef<UpGame> {
  final double _height = 800;
  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox(
      position: Vector2(400, -_height),
      size: Vector2(1, _height),
    ));
  }
}

class BottomBoundary extends PositionComponent
    with CollisionCallbacks, HasGameRef<UpGame> {
  final double _height = 800;
  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox(
      position: Vector2(-400, 0),
      size: Vector2(_height, 1),
    ));
  }
}

class MyParallaxComponent extends ParallaxComponent<UpGame> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax([
      ParallaxImageData('background_sky'),
      ParallaxImageData('background_mountain1'),
      ParallaxImageData('background_mountain2'),
      ParallaxImageData('background_mountain3'),
      ParallaxImageData('background_mountain4'),
      ParallaxImageData('background_hills2'),
      ParallaxImageData('background_hills1'),
    ]);
  }

  @override
  void onMount() {
    super.onMount();
    position = gameRef.projector.unprojectVector(Vector2(0, 0));
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
