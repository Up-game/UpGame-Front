import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:upgame/up_game.dart';

enum PlayerState { idle, running }

class Player extends PositionComponent with HasGameRef<UpGame> {
  final double maxSpeed = 10.0;
  late final SpriteAnimationGroupComponent<PlayerState> _playerAnimation;

  Player();

  PlayerState get animationState => _playerAnimation.current!;

  set animationState(PlayerState state) {
    _playerAnimation.current = state;
  }

  void move(Vector2 direction, double dt) {
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

    _playerAnimation = SpriteAnimationGroupComponent<PlayerState>(
      animations: {
        PlayerState.idle: idleAnimation,
        PlayerState.running: runAnimation,
      },
      current: PlayerState.running,
      size: Vector2.all(100.0),
    );

    add(_playerAnimation);
  }
}
