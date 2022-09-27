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

    const fixedWidth = 810.0;
    final ratio = fixedWidth / size.x;
    camera.viewport =
        FixedResolutionViewport(Vector2(fixedWidth, size.y * ratio));

    // final fixedWidth = 300.0;
    // final ratio = size.x / fixedWidth;
    // camera.viewport =
    //     FixedResolutionViewport(Vector2(fixedWidth, size.y * ratio));

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
    images.load(
      'background/Sky.png',
      key: 'background_sky',
    );
    images.load(
      'background/Hills_1.png',
      key: 'background_hills1',
    );
    images.load(
      'background/Hills_2.png',
      key: 'background_hills2',
    );
    images.load(
      'background/Mountain_1.png',
      key: 'background_mountain1',
    );
    images.load(
      'background/Mountain_2.png',
      key: 'background_mountain2',
    );
    images.load(
      'background/Mountain_3.png',
      key: 'background_mountain3',
    );
    images.load(
      'background/Mountain_4.png',
      key: 'background_mountain4',
    );

    return images.ready();
  }
}
