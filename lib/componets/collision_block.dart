import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  CollisionBlock({position, size, this.isPlatform = false, this.isSand = false}) : super(position: position, size: size){debugMode = false;}

  bool isPlatform;
  bool isSand;
}
