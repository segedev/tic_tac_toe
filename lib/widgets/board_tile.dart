import 'package:flutter/material.dart';
import '../models/player.dart';

class BoardTile extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;

  const BoardTile({Key? key, required this.player, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Text(
            player == Player.none
                ? ''
                : player == Player.x
                    ? 'X'
                    : 'O',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
