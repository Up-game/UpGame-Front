import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:upgame/up_game.dart';

class RayCasting extends PositionComponent with HasGameRef<UpGame> {
  Vector2 direction;
  double length;
  late Ray2 _ray;
  final RaycastResult<ShapeHitbox> result = RaycastResult<ShapeHitbox>();
  final List<ShapeHitbox> _ignoreHitboxes;

  RayCasting({
    super.position,
    required this.direction,
    this.length = 1.0,
    List<ShapeHitbox> ignoreHitboxes = const [],
  })  : _ignoreHitboxes = ignoreHitboxes,
        super() {
    _ray = Ray2(origin: absolutePosition, direction: direction);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  bool get hit {
    return result.intersectionPoint != null && result.distance! <= length;
  }

  void castRay() {
    _ray.direction = direction;
    _ray.origin = absolutePosition;
    gameRef.collisionDetection
        .raycast(_ray, ignoreHitboxes: _ignoreHitboxes, out: result);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void renderDebugMode(Canvas canvas) {
    super.renderDebugMode(canvas);
    canvas.drawLine(Offset.zero, (direction * length).toOffset(),
        Paint()..color = const Color.fromARGB(255, 94, 255, 0));
    if (result.intersectionPoint != null && result.distance! <= length) {
      canvas.drawCircle(
          (result.intersectionPoint! - absolutePosition).toOffset(),
          4,
          Paint()..color = Colors.red);
    }
  }
}
