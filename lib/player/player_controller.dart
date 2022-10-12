import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:upgame/player/player.dart';

import '../button.dart';

abstract class PlayerController {
  late final Player _player;

  set player(Player player) => _player = player;

  void update(double dt);
}

class LocalPlayerController extends PlayerController {
  final JoystickComponent joystick;
  final Button buttonA;
  final Button buttonB;

  final double maxSpeed = 10;
  static const double GRAVITY = 0.5;

  LocalPlayerController(this.joystick, this.buttonA, this.buttonB) {
    buttonA.onPressed = jumpPressed;
    buttonA.onReleased = jumpReleased;
    buttonB.onPressed = specialPressed;
    buttonB.onReleased = specialReleased;
  }

  @override
  void update(double dt) {
    if (joystick.direction != JoystickDirection.idle) {
      _player.playerVisual.playerAnimation.current = PlayerState.running;
      _player.velocity.x = joystick.delta.x * maxSpeed * dt;

      if (joystick.delta.x < 0 &&
          !_player.playerVisual.playerAnimation.isFlippedHorizontally) {
        _player.playerVisual.playerAnimation.flipHorizontallyAroundCenter();
      } else if (joystick.delta.x > 0 &&
          _player.playerVisual.playerAnimation.isFlippedHorizontally) {
        _player.playerVisual.playerAnimation.flipHorizontallyAroundCenter();
      }
    } else {
      _player.playerVisual.playerAnimation.current = PlayerState.idle;
      _player.velocity.x = 0;
    }

    _player.velocity.y += GRAVITY;
  }

  void jumpPressed() {
    debugPrint("jump pressed");
  }

  void jumpReleased() {
    debugPrint("jump released");
  }

  void specialPressed() {
    debugPrint("special pressed");
  }

  void specialReleased() {
    debugPrint("special released");
  }
}
