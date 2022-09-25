import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'game_page.dart';

class UpGame extends FlameGame with HasDraggables, HasCollisionDetection {
  late final RouterComponent router;

  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await loadAssets();

    add(
      router = RouterComponent(
        routes: {
          'game': Route(GamePage.new),
        },
        initialRoute: 'game',
      ),
    );
  }

  Future<void> loadAssets() async {
    images.load(
      'ninja_frog/Idle (32x32).png',
      key: 'frog_idle',
    );
    images.load(
      'ninja_frog/Run (32x32).png',
      key: 'frog_run',
    );

    images.load(
      'joystick/ControllerPosition.png',
      key: 'joystick_position',
    );
    images.load(
      'joystick/ControllerRadius.png',
      key: 'joystick_radius',
    );

    return images.ready();
  }
}
