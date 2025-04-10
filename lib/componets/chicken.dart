import 'dart:async';
import 'dart:ui';

import 'package:demo_basic_game/componets/player.dart';
import 'package:demo_basic_game/pixel_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

enum State {
  idle,
  run,
  hit,
}

class Chicken extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Chicken({super.position, super.size, this.offNeg = 0, this.offPos = 0});

  final double offNeg;
  final double offPos;

  static const double stepTime = 0.05;
  static const double tileSize = 16;
  static const runSpeed = 80;
  static const _bounceheight = 260.0;
  final textureSize = Vector2(32, 34);

  double rangeNeg = 0;
  double rangePos = 0;
  Vector2 velocity = Vector2.zero();
  double moveDirection = 1;
  double targetDirection = -1;
  bool gotStomp = false;

  late final Player player;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;

  @override
  FutureOr<void> onLoad() {
    player = game.player;
    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(24, 26),
    ));
    _loadAllAnimations();
    _calculateRage();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!gotStomp) {
      _updateState();
      _movement(dt);
    }

    super.update(dt);
  }

  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 13);
    _runAnimation = _spriteAnimation('Run', 14);
    _hitAnimation = _spriteAnimation('Hit', 15)..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Enemies/Chicken/$state (32x34).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: textureSize));
  }

  void _calculateRage() {
    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;
  }

  void _movement(dt) {
    velocity.x = 0;

    double playerOFfset = (player.scale.x > 0) ? 0: -player.width;
    double chickenOffset = (scale.x > 0) ? 0: - width;

    if (playerInRange()) {
      targetDirection = (player.x + playerOFfset < position.x + chickenOffset) ?
          -1 : 1;
      velocity.x = targetDirection * runSpeed;
    }
    
    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1)??1;

    position.x += velocity.x * dt;
  }

  bool playerInRange() {
    double playerOFfset = (player.scale.x > 0) ? 0: -player.width;

    return player.x + playerOFfset >= rangeNeg && player.x + playerOFfset <= rangePos &&
    player.y + player.height > position.y && player.y < position.y + height;
  }

  void _updateState() {
    current = (velocity.x  != 0) ? State.run : State.idle;
    if ((moveDirection > 0 && scale.x > 0) || (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void colliedWithPlayer() async {
    if(player.velocity.y > 0 && player.y + player.height > position.y) {
      if(game.playSounds) FlameAudio.play('stomp.wav', volume: game.soundVolume);
      gotStomp = true;
      current = State.hit;
      player.velocity.y = - _bounceheight;

      await animationTicker?.completed;
      removeFromParent();

    } else {
      player.colliedWithEnemy();
    }
  }
}