import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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
  Set<Vector2> _collisions = {};

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
    if (other is Tile) {
      _collisions = intersectionPoints;
      Vector2 offset = Vector2(0, 0);
      for (final point in [intersectionPoints.first]) {
        final dy = (center.y - point.y);
        final dx = (center.x - point.x);

        if (dx.abs() <= dy.abs()) {
          offset.x = dx.sign * ((size.x / 2) - dx.abs());
        } else {
          offset.y = dy.sign * ((size.y / 2) - dy.abs());
        }
        // offset = Vector2(
        //   dx.sign * ((size.x / 2) - dx.abs()),
        //   dy.sign * ((size.y / 2) - dy.abs()),
        // );
      }
      position.add(offset);
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
  }

  void move(Vector2 direction, double dt) {
    lastPosition = position.clone();
    position.add(direction * maxSpeed * dt);
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
  void render(Canvas canvas) {
    super.render(canvas);
    _collisions.forEach((element) {
      canvas.drawCircle(
        Offset(element.x - position.x + size.x / 2,
            element.y - position.y + size.y / 2),
        2,
        Paint()..color = Colors.white,
      );
    });
  }
}
