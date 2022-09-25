import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:upgame/player/player_controller.dart';
import 'package:upgame/up_game.dart';

enum PlayerState { idle, running }

class Player extends PositionComponent
    with HasGameRef<UpGame>, CollisionCallbacks {
  final double maxSpeed = 10.0;
  late final SpriteAnimationGroupComponent<PlayerState> playerAnimation;
  final PlayerController? playerController;
  Vector2 lastPosition;

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
    if (other is ScreenHitbox) {
      final screenSize = gameRef.size;

      final points = intersectionPoints
          .map((p) => gameRef.camera.projectVector(p))
          .toList();

      Vector2 temp = Vector2.zero();

      if (intersectionPoints.any((screenPoint) {
        temp = screenPoint;
        return gameRef.camera.projectVector(screenPoint).x == 0;
      })) {
        // Left wall
        log("left");
        position.x = temp.x + size.x / 2;
      }
      if (intersectionPoints.any((screenPoint) {
        temp = screenPoint;
        return gameRef.camera.projectVector(screenPoint).y == 0;
      })) {
        // Top wall
        log("top");
        position.y = temp.y + size.y / 2;
      }
      if (intersectionPoints.any((screenPoint) {
        temp = screenPoint;
        return screenPoint.x == screenSize.x;
      })) {
        // Right wall
        log("right");
        position.x = temp.x - size.x / 2;
      }
      if (intersectionPoints.any((screenPoint) {
        temp = screenPoint;
        return gameRef.camera.projectVector(screenPoint).y == screenSize.y;
      })) {
        // Bottom wall
        log("bottom");
        position.y = temp.y - size.y / 2;
      }
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
    final rectangleHitbox = RectangleHitbox()..debugColor = Colors.yellow;

    addAll([
      playerAnimation,
      rectangleHitbox,
    ]);
  }
}
