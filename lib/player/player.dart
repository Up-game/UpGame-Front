import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:upgame/player/player_controller.dart';
import 'package:upgame/up_game.dart';
import 'package:upgame/utils.dart';

import '../game_page.dart';
import '../tile.dart';

enum PlayerState { idle, running }

class Player extends PositionComponent
    with HasGameRef<UpGame>, CollisionCallbacks {
  final double maxSpeed = 5.0;
  late final SpriteAnimationGroupComponent<PlayerState> playerAnimation;
  final PlayerController? playerController;
  Vector2 lastPosition;
  Vector2 velocity = Vector2.zero();
  Vector2 _lastVelocity = Vector2.zero();

  Set<Vector2> _collisions = {}; // for debug only TODO remove
  Vector2 _closestCollision = Vector2.zero(); // for debug only TODO remove
  Hitbox _hitbox =
      RectangleHitbox(position: Vector2(0, 0), size: Vector2(0, 0));

  Player({required Vector2 position, this.playerController})
      : lastPosition = position,
        super(
            size: Vector2.all(100), anchor: Anchor.center, position: position) {
    playerController?.player = this;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // block player from moving out of the screen.
    if (other is LeftBoundary) {
      position.x = intersectionPoints.first.x + size.x / 2;
    }
    if (other is RightBoundary) {
      position.x = intersectionPoints.first.x - size.x / 2;
    }
    if (other is BottomBoundary) {
      position.y = intersectionPoints.first.y - size.y / 2;
    }
    if (other is Tile) {}
  }

  @override
  Future<void>? onLoad() async {
    final runAnimation = SpriteSheet(
      image: gameRef.images.fromCache('frog_run'),
      srcSize: Vector2.all(32.0),
    ).createAnimation(row: 0, stepTime: 0.05);

    final idleAnimation = SpriteSheet(
      image: gameRef.images.fromCache('frog_idle'),
      srcSize: Vector2.all(32.0),
    ).createAnimation(row: 0, stepTime: 0.05);

    playerAnimation = SpriteAnimationGroupComponent<PlayerState>(
      animations: {
        PlayerState.idle: idleAnimation,
        PlayerState.running: runAnimation,
      },
      current: PlayerState.running,
      size: size,
    );
    final rectangleHitbox = RectangleHitbox()
      ..debugColor = Colors.yellow
      ..collisionType = CollisionType.passive;

    addAll([
      playerAnimation,
      rectangleHitbox,
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    lastPosition = position.clone();
    _lastVelocity = velocity * maxSpeed * dt;
    position.add(_lastVelocity);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _collisions.forEach((element) {
      canvas.drawCircle(
        Offset(element.x - position.x + size.x / 2,
            element.y - position.y + size.y / 2),
        4,
        Paint()..color = Colors.white,
      );
    });
    canvas.drawCircle(
      Offset(_closestCollision.x - position.x + size.x / 2,
          _closestCollision.y - position.y + size.y / 2),
      5,
      Paint()..color = Colors.red,
    );
    canvas.drawLine(
      (size / 2).toOffset(),
      Offset(_closestCollision.x - position.x + size.x / 2,
          _closestCollision.y - position.y + size.y / 2),
      Paint()..color = Colors.red,
    );
  }
}
