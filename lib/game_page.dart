import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'player.dart';
import 'up_game.dart';

class GamePage extends Component with HasGameRef<UpGame> {
  late final JoystickComponent _joystick;
  Player _player = Player();
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

    _player.position = Vector2(0, 0);

    addAll([
      FpsTextComponent(),
      _player,
      _joystick,
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_joystick.direction != JoystickDirection.idle) {
      _player.animationState = PlayerState.running;
      _player.move(_joystick.delta, dt);
    } else {
      _player.animationState = PlayerState.idle;
    }
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
