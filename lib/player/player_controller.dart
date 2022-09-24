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
      _player.animationState = PlayerState.running;
      _player.move(joystick.delta, dt);
    } else {
      _player.animationState = PlayerState.idle;
    }
  }
}
