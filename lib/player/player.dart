import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:swlame/swlame.dart';
import 'package:upgame/player/player_controller.dart';
import 'package:upgame/raycast/box_casting.dart';
import 'package:upgame/raycast/raycasting.dart';
import 'package:upgame/up_game.dart';

import '../game_page.dart';
import '../tile.dart';

enum PlayerState { idle, running }

class Player extends PositionComponent
    with HasGameRef<UpGame>, DynamicBody<UpGame> {
  final double maxSpeed = 0.5;
  final PlayerController? playerController;
  final playerVisual = PlayerVisual();
  late final RayCasting rayCasting;
  int counter = 0;

  Player({required Vector2 position, this.playerController})
      : super(
            size: Vector2.all(100), anchor: Anchor.center, position: position) {
    playerController?.player = this;
  }

  @override
  Future<void>? onLoad() async {
    addAll([
      playerVisual,
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    resolveCollision();
  }
}

class PlayerVisual extends PositionComponent with HasGameRef<UpGame> {
  late final SpriteAnimationGroupComponent<PlayerState> playerAnimation;

  @override
  Future<void>? onLoad() async {
    debugMode = false;
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

    add(playerAnimation);
  }
}
