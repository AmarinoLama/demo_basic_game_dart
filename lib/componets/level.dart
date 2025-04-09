import 'dart:async';
import 'package:demo_basic_game/componets/collision_block.dart';
import 'package:demo_basic_game/componets/player.dart';
import 'package:demo_basic_game/pixel_adventure.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';

class Level extends World with HasGameRef<PixelAdventure>{
  Level({required this.levelName, required this.player});

  String levelName;
  final Player player;
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    await _addParallaxBackground('Blue');
    _spawnObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            )..priority = 1;
            collisionBlocks.add(platform);
            add(platform);
            break;
          case 'Sand':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isSand: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }

  void _spawnObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer!.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }
  }

  Future<void> _addParallaxBackground(String color) async {
    final parallax = await game.loadParallax(
      [
        ParallaxImageData('Background/$color.png'), // o el color que necesites
      ],
      baseVelocity: Vector2(40, 40), // scroll vertical
      repeat: ImageRepeat.repeat,
      fill: LayerFill.none,
    );

    add(ParallaxComponent(parallax: parallax)..priority = -1);
  }

}
