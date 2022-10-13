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

  LocalPlayerController(this.joystick, this.buttonA, this.buttonB) {
    buttonA.onPressed = jumpPressed;
    buttonA.onReleased = jumpReleased;
    buttonA.onPressedCanceled = jumpReleased;
    buttonB.onPressed = specialPressed;
    buttonB.onReleased = specialReleased;
  }

  @override
  void update(double dt) {
    handleMovement(dt);
    handleJump(dt);
  }

  final double maxSpeed = 10;

  void handleMovement(double dt) {
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
  }

  final double gravity = 200;
  final double maxGravity = 100;
  final double jumpForce = 500;
  final double maxJumpHeight = 200;
  double jumpHeight = 0;

  bool isJumpPressed = false;

  void handleJump(double dt) {
    if (isJumpPressed && jumpHeight <= maxJumpHeight) {
      _player.velocity.y = -jumpForce * dt;
      jumpHeight += _player.velocity.y.abs();
    } else {
      isJumpPressed = false;
      jumpHeight = 0;
      _player.velocity.y += gravity * dt;
      _player.velocity.y = _player.velocity.y.clamp(0, maxGravity);
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
