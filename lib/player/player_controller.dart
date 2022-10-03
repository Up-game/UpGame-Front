import 'package:flame/components.dart';
import 'package:upgame/player/player.dart';

abstract class PlayerController {
  late final Player _player;

  set player(Player player) => _player = player;

  void update(double dt);
}

class LocalPlayerController extends PlayerController {
  final JoystickComponent joystick;

  LocalPlayerController(this.joystick);

  @override
  void update(double dt) {
    if (joystick.direction != JoystickDirection.idle) {
      _player.playerAnimation.current = PlayerState.running;
      _player.rectangleHitbox.velocity += joystick.delta * 0.01;

      if (joystick.delta.x < 0 &&
          !_player.playerAnimation.isFlippedHorizontally) {
        _player.playerAnimation.flipHorizontallyAroundCenter();
      } else if (joystick.delta.x > 0 &&
          _player.playerAnimation.isFlippedHorizontally) {
        _player.playerAnimation.flipHorizontallyAroundCenter();
      }
    } else {
      _player.playerAnimation.current = PlayerState.idle;
    }
  }
}
