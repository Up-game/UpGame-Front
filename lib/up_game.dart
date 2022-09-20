import 'package:flame/game.dart';

import 'game_page.dart';

class UpGame extends FlameGame {
  late final RouterComponent router;

  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await images.load(
      'ninja_frog/Idle (32x32).png',
      key: 'frog_idle',
    );
    await images.load(
      'ninja_frog/Run (32x32).png',
      key: 'frog_run',
    );

    add(
      router = RouterComponent(
        routes: {
          'game': Route(GamePage.new),
        },
        initialRoute: 'game',
      ),
    );
  }
}
