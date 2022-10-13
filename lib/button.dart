import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class Button extends HudButtonComponent {
  void Function()? onPressedCanceled;

  Button({required Sprite sprite, required Vector2 size, EdgeInsets? margin})
      : super(
          button: SpriteComponent(
            sprite: sprite,
            size: size,
          ),
          buttonDown: SpriteComponent(
            sprite: sprite,
            size: size,
          ),
          margin: margin,
        );

  @override
  bool onTapCancel() {
    onPressedCanceled?.call();
    return super.onTapCancel();
  }
}
