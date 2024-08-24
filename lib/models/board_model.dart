import 'dart:math';

import 'player.dart';

class BoardModel {
  List<List<Player>> board;

  BoardModel()
      : board = List.generate(
          3,
          (_) => List.generate(3, (_) => Player.none),
        );

  void reset() {
    for (var row in board) {
      for (int i = 0; i < row.length; i++) {
        row[i] = Player.none;
      }
    }
  }

  Player getWinner() {
    // Check rows
    for (var row in board) {
      if (row[0] != Player.none && row[0] == row[1] && row[1] == row[2]) {
        return row[0];
      }
    }
    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[0][i] != Player.none &&
          board[0][i] == board[1][i] &&
          board[1][i] == board[2][i]) {
        return board[0][i];
      }
    }
    // Check diagonals
    if (board[0][0] != Player.none &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      return board[0][0];
    }
    if (board[0][2] != Player.none &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      return board[0][2];
    }
    return Player.none;
  }

  bool isFull() {
    for (var row in board) {
      if (row.contains(Player.none)) {
        return false;
      }
    }
    return true;
  }

  void makeMove(int row, int col, Player player) {
    if (board[row][col] == Player.none) {
      board[row][col] = player;
    }
  }

  void resetBoard() {
    for (var row in board) {
      for (int i = 0; i < row.length; i++) {
        row[i] = Player.none;
      }
    }
  }

  // Minimax algorithm for hard AI
  int minimax(int depth, bool isMaximizing) {
    Player winner = getWinner();
    if (winner != Player.none) {
      if (winner == Player.x) return 10 - depth;
      if (winner == Player.o) return depth - 10;
    }

    if (isFull()) return 0;

    if (isMaximizing) {
      int bestScore = -9999;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == Player.none) {
            board[i][j] = Player.x;
            int score = minimax(depth + 1, false);
            board[i][j] = Player.none;
            bestScore = max(score, bestScore);
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 9999;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == Player.none) {
            board[i][j] = Player.o;
            int score = minimax(depth + 1, true);
            board[i][j] = Player.none;
            bestScore = min(score, bestScore);
          }
        }
      }
      return bestScore;
    }
  }

  // Method to get the best move for the AI
  List<int> getBestMove(Player aiPlayer) {
    int bestScore = -9999;
    List<int> bestMove = [-1, -1];

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == Player.none) {
          board[i][j] = aiPlayer;
          int score = minimax(0, aiPlayer == Player.x ? false : true);
          board[i][j] = Player.none;
          if (score > bestScore) {
            bestScore = score;
            bestMove = [i, j];
          }
        }
      }
    }
    return bestMove;
  }
}

// import 'dart:math';
// import '../models/player.dart';

// class Board {
//   final List<List<Player>> board;

//   Board()
//       : board = List.generate(3, (_) => List.generate(3, (_) => Player.none));

//   Player getWinner() {
//     // Check rows and columns
//     for (int i = 0; i < 3; i++) {
//       if (board[i][0] != Player.none &&
//           board[i][0] == board[i][1] &&
//           board[i][1] == board[i][2]) {
//         return board[i][0];
//       }
//       if (board[0][i] != Player.none &&
//           board[0][i] == board[1][i] &&
//           board[1][i] == board[2][i]) {
//         return board[0][i];
//       }
//     }

//     // Check diagonals
//     if (board[0][0] != Player.none &&
//         board[0][0] == board[1][1] &&
//         board[1][1] == board[2][2]) {
//       return board[0][0];
//     }
//     if (board[0][2] != Player.none &&
//         board[0][2] == board[1][1] &&
//         board[1][1] == board[2][0]) {
//       return board[0][2];
//     }

//     // Check for draw or ongoing game
//     if (board.expand((element) => element).contains(Player.none)) {
//       return Player.none; // Game still ongoing
//     }
//     return Player.none; // Draw
//   }

//   bool isFull() {
//     for (var row in board) {
//       if (row.contains(Player.none)) {
//         return false;
//       }
//     }
//     return true;
//   }

//   void makeMove(int row, int col, Player player) {
//     if (board[row][col] == Player.none) {
//       board[row][col] = player;
//     }
//   }

//   void resetBoard() {
//     for (var row in board) {
//       for (int i = 0; i < row.length; i++) {
//         row[i] = Player.none;
//       }
//     }
//   }

//   // Minimax algorithm for hard AI
//   int minimax(int depth, bool isMaximizing) {
//     Player winner = getWinner();
//     if (winner != Player.none) {
//       if (winner == Player.x) return 10 - depth;
//       if (winner == Player.o) return depth - 10;
//     }

//     if (isFull()) return 0;

//     if (isMaximizing) {
//       int bestScore = -9999;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == Player.none) {
//             board[i][j] = Player.x;
//             int score = minimax(depth + 1, false);
//             board[i][j] = Player.none;
//             bestScore = max(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     } else {
//       int bestScore = 9999;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == Player.none) {
//             board[i][j] = Player.o;
//             int score = minimax(depth + 1, true);
//             board[i][j] = Player.none;
//             bestScore = min(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     }
//   }

//   // Method to get the best move for the AI
//   List<int> getBestMove(Player aiPlayer) {
//     int bestScore = -9999;
//     List<int> bestMove = [-1, -1];

//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == Player.none) {
//           board[i][j] = aiPlayer;
//           int score = minimax(0, aiPlayer == Player.x ? false : true);
//           board[i][j] = Player.none;
//           if (score > bestScore) {
//             bestScore = score;
//             bestMove = [i, j];
//           }
//         }
//       }
//     }
//     return bestMove;
//   }
// }
