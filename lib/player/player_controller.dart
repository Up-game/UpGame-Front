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
  final double gravity = 40;
  final double maxGravity = 10;
  final double jumpForce = 70;
  final double jumpDrag = 30;

  final JoystickComponent joystick;
  final Button buttonA;
  final Button buttonB;

  final double maxSpeed = 10;
  bool isJumpPressed = false;
  double maxAirTime = 0.3;
  double minAirTime = 0.15;
  double airTime = 0;

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

    if (isJumpPressed && airTime <= maxAirTime ||
        airTime <= minAirTime && airTime != 0) {
      airTime += dt;
      _player.velocity.y -=
          (jumpForce - ((1 + airTime * airTime) * jumpDrag)) * dt;
    } else {
      isJumpPressed = false;
      _player.velocity.y += gravity * dt;
      _player.velocity.y = _player.velocity.y.clamp(0, maxGravity);
    }

    if (_player.isGrounded && airTime > minAirTime) {
      airTime = 0;
    }
  }

  void jumpPressed() {
    if (_player.isGrounded) {
      isJumpPressed = true;
    }

    debugPrint("jump pressed");
  }

  void jumpReleased() {
    isJumpPressed = false;
    debugPrint("jump released");
  }

  void specialPressed() {
    debugPrint("special pressed");
  }

  void specialReleased() {
    debugPrint("special released");
  }
}
