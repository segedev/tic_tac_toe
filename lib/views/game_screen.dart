import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player.dart';
import '../view_models/game_view_model.dart';
import '../widgets/board_tile.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameViewModel = context.watch<GameViewModel>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 46, 78),
      appBar: AppBar(
        title: Text(
          'Tic-Tac-Toe',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 6, 46, 78),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              gameViewModel.resetGame();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final row = index ~/ 3;
                final col = index % 3;
                return BoardTile(
                  player: gameViewModel.board.board[row][col],
                  onTap: () {
                    gameViewModel.makeMove(row, col);
                  },
                );
              },
              itemCount: 9,
            ),
          ),
          if (gameViewModel.isGameOver) ...[
            SizedBox(height: 20),
            Text(
              gameViewModel.board.getWinner() == Player.none
                  ? 'It\'s a Draw!'
                  : 'Player ${gameViewModel.board.getWinner() == Player.x ? 'X' : 'O'} Wins!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
