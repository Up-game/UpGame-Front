import 'package:flame/collisions.dart';
import 'package:swlame/src/swlame.dart';

class SwlamBroadphase<T extends Hitbox<T>> extends Broadphase<T> {
  SwlamBroadphase({super.items});

  late final List<T> _active = [];
  late final Set<CollisionProspect<T>> _potentials = {};
  final Set<MovingRectangleHitbox> _movingHitboxes = {};

  Set<MovingRectangleHitbox> get movingHitboxes =>
      Set.unmodifiable(_movingHitboxes);

  @override
  void update() {
    items.sort((a, b) => a.aabb.min.x.compareTo(b.aabb.min.x));
  }

  @override
  Set<CollisionProspect<T>> query() {
    _active.clear();
    _potentials.clear();
    _movingHitboxes.clear();

    for (final item in items) {
      if (item is MovingRectangleHitbox) {
        _movingHitboxes.add(item as MovingRectangleHitbox);
      }
      if (item.collisionType == CollisionType.inactive) {
        continue;
      }
      if (_active.isEmpty) {
        _active.add(item);
        continue;
      }
      final currentBox = item.aabb;
      final currentMin = currentBox.min.x;
      for (var i = _active.length - 1; i >= 0; i--) {
        final activeItem = _active[i];
        final activeBox = activeItem.aabb;
        if (activeBox.max.x >= currentMin) {
          if (item.collisionType == CollisionType.active ||
              activeItem.collisionType == CollisionType.active) {
            _potentials.add(CollisionProspect<T>(item, activeItem));
          }
        } else {
          _active.remove(activeItem);
        }
      }
      _active.add(item);
    }
    return _potentials;
  }
}
