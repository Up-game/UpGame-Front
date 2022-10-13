import 'package:flame/game.dart';
import 'package:swlame/swlame.dart';

import 'game_page.dart';

class UpGame extends FlameGame
    with Swlame, HasDraggables, HasCollisionDetection, HasTappables {
  late final RouterComponent router;

  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await loadAssets();

    const fixedWidth = 800.0;
    final ratio = fixedWidth / size.x;
    camera.viewport =
        FixedResolutionViewport(Vector2(fixedWidth, size.y * ratio));

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
    Map<String, String> assets = {
      'frog_idle': 'ninja_frog/Idle (32x32).png',
      'frog_run': 'ninja_frog/Run (32x32).png',
      'frog_jump': 'ninja_frog/Jump (32x32).png',
      'frog_fall': 'ninja_frog/Fall (32x32).png',
      'joystick_position': 'joystick/ControllerPosition.png',
      'joystick_radius': 'joystick/ControllerRadius.png',
      'button_a': 'joystick/button_a.png',
      'button_b': 'joystick/button_b.png',
      'background_sky': 'background/Sky.png',
      'background_hills1': 'background/Hills_1.png',
      'background_hills2': 'background/Hills_2.png',
      'background_mountain1': 'background/Mountain_1.png',
      'background_mountain2': 'background/Mountain_2.png',
      'background_mountain3': 'background/Mountain_3.png',
      'background_mountain4': 'background/Mountain_4.png',
      'grass': 'tiles/Grass.png',
    };

    for (var entry in assets.entries) {
      images.load(entry.value, key: entry.key);
    }

    return images.ready();
  }
}
