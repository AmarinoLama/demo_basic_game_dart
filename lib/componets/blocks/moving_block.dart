import 'dart:async';
import 'package:demo_basic_game/componets/collision_block.dart';
import 'package:demo_basic_game/componets/entities/player.dart';
import 'package:demo_basic_game/pixel_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class MovingBlock extends CollisionBlock
    with CollisionCallbacks, HasGameRef<PixelAdventure> {

  // Constructor y atributos
  MovingBlock({super.position, super.size, this.offNeg = 0, this.offPos = 0});
  final double offNeg;
  final double offPos;

  // Parte de las imágenes
  late final SpriteComponent spriteComponent;
  Sprite get idleSprite =>
      Sprite(game.images.fromCache('Traps/Rock Head/Idle.png'));

  // Lógica de movimiento
  late final Player player;
  late double initialX;
  double pushSpeed = 50.0;
  int pushDirection = 0;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    priority = 1;
    debugMode = true;

    player = game.player;
    initialX = position.x;

    add(
      RectangleHitbox()..collisionType = CollisionType.passive,
    );

    spriteComponent = SpriteComponent(
      sprite: idleSprite,
      size: size,
      position: Vector2.zero(),
    );
    await add(spriteComponent);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      final playerMid = other.position.x + other.size.x / 2;
      final blockMid = position.x + size.x / 2;

      if (playerMid < blockMid && player.isOnground) {
        pushDirection = 1; // empujado hacia la derecha
      } else {
        pushDirection = -1; // empujado hacia la izquierda
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      pushDirection = 0; // dejar de moverse al terminar la colisión
    }
    super.onCollisionEnd(other);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (pushDirection != 0) {
      final movement = pushSpeed * dt * pushDirection;
      final newX = position.x + movement;


        position.x = newX;

    }
  }
}
