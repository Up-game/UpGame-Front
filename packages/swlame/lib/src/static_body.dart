import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';

import 'dynamic_body.dart';
import 'swlame.dart';

mixin StaticBody<T extends Swlame> on PositionComponent, HasGameRef<T> {
  final Ray2 ray = Ray2.zero();
  RectangleHitbox? resizedHitbox;

  RaycastResult<ShapeHitbox>? rayIntersection(DynamicBody body,
      {RaycastResult<ShapeHitbox>? out}) {
    resizedHitbox = RectangleHitbox(
        size: size + body.size,
        position: absolutePosition - body.size / 2,
        isSolid: true);

    ray.origin = body.center;
    ray.direction = body.velocity.normalized();
    final result = resizedHitbox!.rayIntersection(ray, out: out);
    return result;
  }

  @mustCallSuper
  @override
  Future<void>? onLoad() {
    gameRef.staticBodies.add(this);
    return super.onLoad();
  }
}
