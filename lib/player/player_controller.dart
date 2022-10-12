import 'package:flame/components.dart';
import 'package:upgame/player/player.dart';

abstract class PlayerController {
  late final Player _player;

  set player(Player player) => _player = player;

  void update(double dt);
}

class LocalPlayerController extends PlayerController {
  final JoystickComponent joystick;
  final double maxSpeed = 10;

  LocalPlayerController(this.joystick);

  @override
  void update(double dt) {
    if (joystick.direction != JoystickDirection.idle) {
      _player.playerVisual.playerAnimation.current = PlayerState.running;
      _player.velocity.setFrom(joystick.delta * maxSpeed * dt);

      if (joystick.delta.x < 0 &&
          !_player.playerVisual.playerAnimation.isFlippedHorizontally) {
        _player.playerVisual.playerAnimation.flipHorizontallyAroundCenter();
      } else if (joystick.delta.x > 0 &&
          _player.playerVisual.playerAnimation.isFlippedHorizontally) {
        _player.playerVisual.playerAnimation.flipHorizontallyAroundCenter();
      }
    } else {
      _player.playerVisual.playerAnimation.current = PlayerState.idle;
      _player.velocity.setFrom(Vector2.zero());
    }
  }
}
