import 'dart:async';

import 'package:demo_basic_game/pixel_adventure.dart';
import 'package:flame/components.dart';

class BackgroundTile extends SpriteComponent with  HasGameRef<PixelAdventure>{

  BackgroundTile({this.color = 'Gray', position}) : super (position: position);
  final String color;

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(64);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }
}