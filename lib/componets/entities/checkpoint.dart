import 'dart:async';

import 'package:demo_basic_game/componets/entities/player.dart';
import 'package:demo_basic_game/pixel_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Checkpoint({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        position: Vector2(18, 56),
        size: Vector2(12, 8),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
        'Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png',
      ),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Player) _reachedCheckpoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckpoint() async {
    animation =
        animation = SpriteAnimation.fromFrameData(
          game.images.fromCache(
            'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png',
          ),
          SpriteAnimationData.sequenced(
            amount: 26,
            stepTime: 0.05,
            textureSize: Vector2.all(64),
            loop: false,
          ),
        );

    await animationTicker?.completed;
    animationTicker?.reset();

    animation =
        animation = SpriteAnimation.fromFrameData(
          game.images.fromCache(
            'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png',
          ),
          SpriteAnimationData.sequenced(
            amount: 10,
            stepTime: 0.05,
            textureSize: Vector2.all(64),
          ),
        );
  }
}