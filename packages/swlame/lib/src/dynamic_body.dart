import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:swlame/swlame.dart';
import 'swlame.dart';

mixin DynamicBody<T extends Swlame> on PositionComponent, HasGameRef<T> {
  final Vector2 velocity = Vector2.zero();

  @mustCallSuper
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    gameRef.dynamicBodies.add(this);
  }

  void resolveCollision() {
    final RaycastResult<ShapeHitbox> result = RaycastResult();

    if (velocity.length > 0) {
      List<ShapeHitbox> ignoreHitboxes = [];
      while (true) {
        bool hit =
            _rayCast(out: result, ignoreHitboxes: ignoreHitboxes) != null &&
                result.intersectionPoint != null;

        if (hit && result.distance! <= velocity.length) {
          double diff = (velocity.length - result.distance!) / velocity.length;
          final velocityCorr = (velocity.clone()
                ..absolute()
                ..multiply(result.normal!)) *
              diff;
          velocity
              .setFrom(velocity + velocityCorr + result.normal! * 0.000000001);
          ignoreHitboxes.add(result.hitbox!);
        } else {
          break;
        }
      }
      position.add(velocity);
    }
  }

  RaycastResult<ShapeHitbox>? _rayCast({
    List<ShapeHitbox>? ignoreHitboxes,
    RaycastResult<ShapeHitbox>? out,
  }) {
    final RaycastResult<ShapeHitbox> temporaryResult = RaycastResult();
    RaycastResult<ShapeHitbox>? finalResult = out?..reset();

    for (final body in gameRef.staticBodies) {
      if (ignoreHitboxes?.contains(body.resizedHitbox) ?? false) {
        continue;
      }
      final currentResult = body.rayIntersection(this, out: temporaryResult);
      final possiblyFirstResult = !(finalResult?.isActive ?? false);

      if (currentResult != null &&
          (possiblyFirstResult ||
              currentResult.distance! < finalResult!.distance!)) {
        if (finalResult == null) {
          finalResult = currentResult.clone();
        } else {
          finalResult.setFrom(currentResult);
        }
      }
    }
    return (finalResult?.isActive ?? false) ? finalResult : null;
  }
}
