import 'dart:async';
import 'dart:ui';

import 'package:demo_basic_game/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PixelAdventure extends FlameGame {

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;

  final world = Level(levelName: 'Level-02');
  
  @override
  FutureOr<void> onLoad() async {
    // Cargar todas las imágenes en caché
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(width: 640, height: 360, world: world);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    return super.onLoad();
  }
}