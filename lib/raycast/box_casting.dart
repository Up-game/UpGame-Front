import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../up_game.dart';

class BoxCasting extends PositionComponent with HasGameRef<UpGame> {
  final Vector2 direction;
  final double length;
  final Vector2 boxSize;
  late final RectangleHitbox rect;

  BoxCasting({
    Vector2? position,
    required this.direction,
    this.length = 1.0,
    required this.boxSize,
  }) : super(position: position, anchor: Anchor.topLeft);

  @override
  Future<void>? onLoad() {
    rect = RectangleHitbox(
      position: direction * length,
      size: boxSize,
      anchor: Anchor.center,
    );
    rect.debugColor = Color.fromARGB(255, 94, 255, 0);
    add(rect);
  }

  @override
  void update(double dt) {
    super.update(dt);
    rect.position = direction * length;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!debugMode) return;

    canvas.drawLine(
      Offset.zero,
      (direction * length).toOffset(),
      Paint()..color = Color.fromARGB(255, 94, 255, 0),
    );
  }
}
