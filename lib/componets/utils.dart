bool checkCollision(player, block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.size.x;
  final playerHeight = player.size.y;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.size.x;
  final blockHeight = block.size.y;

  final fixedX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  return (playerY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
