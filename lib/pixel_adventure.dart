import 'dart:async';
import 'dart:ui';

import 'package:demo_basic_game/componets/level.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'componets/player.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;
  late JoystickComponent joystick;
  Player player = Player();
  bool showJoystick = false;

  @override
  FutureOr<void> onLoad() async {
    // Cargar todas las imágenes en caché
    await images.loadAllImages();

    final world = Level(levelName: 'Level-02', player: player);

    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: world,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
        size: Vector2.all(50),
      ),
      knobRadius: 40,
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
        size: Vector2.all(100),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32)
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
