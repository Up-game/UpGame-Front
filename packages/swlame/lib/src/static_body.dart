import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';

import 'dynamic_body.dart';
import 'swlame.dart';

mixin StaticBody<T extends Swlame> on PositionComponent, HasGameRef<T> {
  final RectangleHitbox resizedHitbox = RectangleHitbox();
  final Ray2 ray = Ray2.zero();

  RaycastResult<ShapeHitbox>? rayIntersection(DynamicBody body,
      {RaycastResult<ShapeHitbox>? out}) {
    resizedHitbox.size = size + body.size;
    resizedHitbox.position = absolutePosition - body.size / 2;
    ray.origin = body.center;
    ray.direction = body.velocity.normalized();

    return resizedHitbox.rayIntersection(ray, out: out);
  }

  @mustCallSuper
  @override
  Future<void>? onLoad() {
    gameRef.staticBodies.add(this);
    return super.onLoad();
  }
}
