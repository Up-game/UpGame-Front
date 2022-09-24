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
    gameRef.camera.followVector2(Vector2(0, 0));
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
    _player =
        Player(position: Vector2(0, 0), playerController: _playerController);

    _player.position = Vector2(0, 0);

    addAll([
      FpsTextComponent(),
      _player,
      _joystick,
      ScreenHitbox(),
    ]);
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
