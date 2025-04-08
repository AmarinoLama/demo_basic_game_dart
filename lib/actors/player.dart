import 'dart:async';

import 'package:demo_basic_game/pixel_adventure.dart';
import 'package:flame/components.dart';

enum PlayerState {
  idle,
  running,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {

  Player({position, required this.character}) : super(position: position);


  String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.01;

  PlayerDirection playerDirection = PlayerDirection.none;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {

    idleAnimation = _spriteAnimation(state: 'Idle', amount: 11);
    runningAnimation = _spriteAnimation(state: 'Run', amount: 12);

    // Lista de animaciones
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    // Settear la animación default
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation({required amount, required state, double vector = 32}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(vector),
      ),
    );
  }
}