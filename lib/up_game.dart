import 'package:flame/game.dart';

import 'game_page.dart';

class UpGame extends FlameGame {
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    await images.load(
      'Idle (32x32).png',
      key: 'frog_idle',
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
