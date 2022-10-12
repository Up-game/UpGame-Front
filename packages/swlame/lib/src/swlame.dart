import 'package:flame/game.dart';

import 'dynamic_body.dart';
import 'static_body.dart';

mixin Swlame on FlameGame {
  List<StaticBody> staticBodies = [];
  List<DynamicBody> dynamicBodies = [];
}
