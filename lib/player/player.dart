import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:swlame/swlame.dart';
import 'package:upgame/player/player_controller.dart';
import 'package:upgame/raycast/raycasting.dart';
import 'package:upgame/up_game.dart';

enum PlayerState { idle, running, jumping, falling }

class Player extends PositionComponent
    with HasGameRef<UpGame>, DynamicBody<UpGame> {
  final PlayerController? playerController;
  late final PlayerVisual playerVisual;
  late final RayCasting groundRay;
  late final RayCasting leftRay;
  late final RayCasting rightRay;
  int counter = 0;

  bool get isGrounded => groundRay.hit;
  bool get isAgainstLeftWall => leftRay.hit;
  bool get isAgainstRightWall => rightRay.hit;

  Player({required Vector2 position, this.playerController})
      : super(
            size: Vector2.all(100), anchor: Anchor.center, position: position) {
    playerController?.player = this;
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    playerVisual = PlayerVisual(size: size);
    groundRay = RayCasting(
      position: Vector2(50, 90),
      direction: Vector2(0, 1),
      length: 20,
    );
    leftRay = RayCasting(
      position: Vector2(10, 50),
      direction: Vector2(-1, 0),
      length: 20,
    );
    rightRay = RayCasting(
      position: Vector2(90, 50),
      direction: Vector2(1, 0),
      length: 20,
    );

    add(playerVisual);
    add(groundRay);
    add(leftRay);
    add(rightRay);
  }

  @override
  void update(double dt) {
    super.update(dt);
    groundRay.castRay();
    leftRay.castRay();
    rightRay.castRay();
    playerController?.update(dt);
    resolveCollision();
    position.add(velocity);
  }
}

class PlayerVisual extends PositionComponent with HasGameRef<UpGame> {
  late final SpriteAnimationGroupComponent<PlayerState> playerAnimation;

  PlayerVisual({Vector2? size}) : super(size: size);

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

    final jumpAnimation = SpriteSheet(
      image: gameRef.images.fromCache('frog_jump'),
      srcSize: Vector2.all(32.0),
    ).createAnimation(row: 0, stepTime: 0.05);

    final fallAnimation = SpriteSheet(
      image: gameRef.images.fromCache('frog_fall'),
      srcSize: Vector2.all(32.0),
    ).createAnimation(row: 0, stepTime: 0.05);

    playerAnimation = SpriteAnimationGroupComponent<PlayerState>(
      animations: {
        PlayerState.idle: idleAnimation,
        PlayerState.running: runAnimation,
        PlayerState.jumping: jumpAnimation,
        PlayerState.falling: fallAnimation,
      },
      current: PlayerState.idle,
      size: size,
    );

    add(playerAnimation);
  }
}
