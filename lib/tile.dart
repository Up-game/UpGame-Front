import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:upgame/up_game.dart';

class Tile extends PositionComponent with HasGameRef<UpGame> {
  String tileName;
  Vector2 playerSize = Vector2.all(100);

  Tile(this.tileName, {Vector2? size, Vector2? position})
      : super(size: size, position: position);

  @override
  Future<void>? onLoad() async {
    final grassImage = gameRef.images.fromCache(tileName);
    final grassSprite = Sprite(grassImage);

    final parallaxComponent = await ParallaxComponent.load(
      [ParallaxImageData('grass')],
      repeat: ImageRepeat.repeat,
      size: size,
      fill: LayerFill.height,
    );

    add(parallaxComponent);
    add(RectangleHitbox());
    add(RectangleHitbox(size: size + playerSize, position: -playerSize / 2));
  }
}
