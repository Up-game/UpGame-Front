import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:swlame/swlame.dart';
import 'package:upgame/player/player_controller.dart';
import 'package:upgame/up_game.dart';

import '../game_page.dart';
import '../tile.dart';

enum PlayerState { idle, running }

class Player extends PositionComponent
    with HasGameRef<UpGame>, CollisionCallbacks {
  final double maxSpeed = 5.0;
  late final SpriteAnimationGroupComponent<PlayerState> playerAnimation;
  final PlayerController? playerController;
  late final MovingRectangleHitbox rectangleHitbox;
  Vector2 velocity = Vector2.zero();

  Player({required Vector2 position, this.playerController})
      : super(
            size: Vector2.all(100), anchor: Anchor.center, position: position) {
    playerController?.player = this;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // block player from moving out of the screen.
    //log(other.runtimeType.toString() + ' ' + this.position.toString());
    // if (other is LeftBoundary) {
    //   position.x = intersectionPoints.first.x + size.x / 2;
    // }
    // if (other is RightBoundary) {
    //   position.x = intersectionPoints.first.x - size.x / 2;
    // }
    // if (other is BottomBoundary) {
    //   position.y = intersectionPoints.first.y - size.y / 2;
    // }
    // if (other is Tile) {}
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
    rectangleHitbox = MovingRectangleHitbox()
      ..debugColor = Colors.yellow
      ..collisionType = CollisionType.passive;

    addAll([
      //playerAnimation,
      rectangleHitbox,
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(rectangleHitbox.velocity);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (final mhb in rectangleHitbox.hitboxesDebug) {
      canvas.drawRect(
        Rect.fromLTWH(
          mhb.x - position.x + (size.x / 2),
          mhb.y - position.y + (size.y / 2),
          mhb.width,
          mhb.height,
        ),
        Paint()
          ..color = Colors.cyan
          ..style = PaintingStyle.stroke,
      );
    }
    for (final point in rectangleHitbox.intersectionPointDebug) {
      canvas.drawCircle(
        Offset(point.x - position.x + (size.x / 2),
            point.y - position.y + (size.y / 2)),
        3,
        Paint()..color = Colors.green,
      );
    }
    canvas.drawLine(
      Offset(size.x / 2, size.y / 2),
      Offset(rectangleHitbox.normalVectorDebug.x + size.x / 2,
          rectangleHitbox.normalVectorDebug.y + size.y / 2),
      Paint()..color = Colors.purple,
    );
  }
}
