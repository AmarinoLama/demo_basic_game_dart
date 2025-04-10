import 'dart:async';

import 'package:demo_basic_game/pixel_adventure.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class JumpButton extends SpriteComponent with HasGameRef<PixelAdventure>, TapCallbacks {

  JumpButton();

  final margin = 32;
  final buttonSize = 100;

  @override
  FutureOr<void> onLoad() {
    priority = 2;
    sprite = Sprite(game.images.fromCache('HUD/jumpButton.png'));
    size = Vector2.all(100);
    position = Vector2(
      game.size.x - margin - buttonSize,
      game.size.y - margin - buttonSize,
    );
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}