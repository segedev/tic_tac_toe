import 'dart:math';

import 'package:flutter/material.dart';
import '../models/board_model.dart';
import '../models/player.dart';

enum Difficulty { easy, medium, hard }

class GameViewModel extends ChangeNotifier {
  final BoardModel _boardModel = BoardModel();
  Player _currentPlayer = Player.x;
  Difficulty _difficulty = Difficulty.easy;
  bool _isGameOver = false;

  BoardModel get board => _boardModel;
  Player get currentPlayer => _currentPlayer;
  bool get isGameOver => _isGameOver;
  Difficulty get difficulty => _difficulty;

  void resetGame() {
    _boardModel.reset();
    _currentPlayer = Player.x;
    _isGameOver = false;
    notifyListeners();
  }

  void setDifficulty(Difficulty difficulty) {
    _difficulty = difficulty;
    resetGame();
    notifyListeners();
  }

  void makeMove(int row, int col) {
    if (_isGameOver || _boardModel.board[row][col] != Player.none) {
      return;
    }

    _boardModel.board[row][col] = _currentPlayer;

    if (_boardModel.getWinner() != Player.none) {
      _isGameOver = true;
      notifyListeners();
      return;
    }

    if (_boardModel.isFull()) {
      _isGameOver = true;
      notifyListeners();
      return;
    }

    _currentPlayer = _currentPlayer == Player.x ? Player.o : Player.x;

    if (_currentPlayer == Player.o) {
      _computerMove();
    }

    notifyListeners();
  }

  void _computerMove() {
    switch (_difficulty) {
      case Difficulty.easy:
        _easyMove();
        break;
      case Difficulty.medium:
        _mediumMove();
        break;
      case Difficulty.hard:
        _hardMove();
        break;
    }
  }

  // void _easyMove() {
  //   // Simple random move logic
  //   for (int i = 0; i < 3; i++) {
  //     for (int j = 0; j < 3; j++) {
  //       if (_boardModel.board[i][j] == Player.none) {
  //         _boardModel.board[i][j] = Player.o;
  //         if (_boardModel.getWinner() != Player.none || _boardModel.isFull()) {
  //           _isGameOver = true;
  //         }
  //         _currentPlayer = Player.x;
  //         return;
  //       }
  //     }
  //   }
  // }
  void _easyMove() {
    // Check if AI can block the player's winning move
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_boardModel.board[i][j] == Player.none) {
          // Simulate the player's move
          _boardModel.board[i][j] = Player.x;
          if (_boardModel.getWinner() == Player.x) {
            // Block the player's winning move
            _boardModel.board[i][j] = Player.o;
            _currentPlayer = Player.x;
            return;
          } else {
            // Reset the cell if not a winning move
            _boardModel.board[i][j] = Player.none;
          }
        }
      }
    }

    // If no need to block, make a random move
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_boardModel.board[i][j] == Player.none) {
          _boardModel.board[i][j] = Player.o;
          if (_boardModel.getWinner() != Player.none || _boardModel.isFull()) {
            _isGameOver = true;
          }
          _currentPlayer = Player.x;
          return;
        }
      }
    }
  }

  // void _mediumMove() {
  //   // Some smarter move logic
  //   // ...
  // }
  void _mediumMove() {
    // Check if AI can win
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_boardModel.board[i][j] == Player.none) {
          // Simulate AI move
          _boardModel.board[i][j] = Player.o;
          if (_boardModel.getWinner() == Player.o) {
            // AI wins
            _currentPlayer = Player.x;
            return;
          } else {
            _boardModel.board[i][j] = Player.none;
          }
        }
      }
    }

    // If AI cannot win, check if AI needs to block player's win
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_boardModel.board[i][j] == Player.none) {
          // Simulate player's move
          _boardModel.board[i][j] = Player.x;
          if (_boardModel.getWinner() == Player.x) {
            // Block the player's winning move
            _boardModel.board[i][j] = Player.o;
            _currentPlayer = Player.x;
            return;
          } else {
            _boardModel.board[i][j] = Player.none;
          }
        }
      }
    }

    // If no need to block or win, make a random move
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_boardModel.board[i][j] == Player.none) {
          _boardModel.board[i][j] = Player.o;
          if (_boardModel.getWinner() != Player.none || _boardModel.isFull()) {
            _isGameOver = true;
          }
          _currentPlayer = Player.x;
          return;
        }
      }
    }
  }

  // void _hardMove() {
  //   // Implement the minimax algorithm here for a difficult opponent
  //   _minimaxMove();
  // }

  void _minimaxMove() {
    // Minimax algorithm implementation
    // ...
  }

  int _minimax(List<List<Player>> board, int depth, bool isMaximizing) {
    Player winner = _boardModel.getWinner();

    if (winner == Player.o) return 10 - depth;
    if (winner == Player.x) return depth - 10;
    if (_boardModel.isFull()) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == Player.none) {
            board[i][j] = Player.o;
            int score = _minimax(board, depth + 1, false);
            board[i][j] = Player.none;
            bestScore = max(score, bestScore);
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == Player.none) {
            board[i][j] = Player.x;
            int score = _minimax(board, depth + 1, true);
            board[i][j] = Player.none;
            bestScore = min(score, bestScore);
          }
        }
      }
      return bestScore;
    }
  }

  void _hardMove() {
    int bestScore = -1000;
    int bestMoveRow = -1;
    int bestMoveCol = -1;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_boardModel.board[i][j] == Player.none) {
          _boardModel.board[i][j] = Player.o;
          int moveScore = _minimax(_boardModel.board, 0, false);
          _boardModel.board[i][j] = Player.none;

          if (moveScore > bestScore) {
            bestScore = moveScore;
            bestMoveRow = i;
            bestMoveCol = j;
          }
        }
      }
    }

    _boardModel.board[bestMoveRow][bestMoveCol] = Player.o;
    if (_boardModel.getWinner() != Player.none || _boardModel.isFull()) {
      _isGameOver = true;
    }
    _currentPlayer = Player.x;
  }

  // int _minimax(BoardModel board, int depth, bool isMaximizing) {
  //   Player winner = board.getWinner();
  //   if (winner == Player.o) {
  //     return 10 - depth;
  //   } else if (winner == Player.x) {
  //     return depth - 10;
  //   } else if (board.isFull()) {
  //     return 0;
  //   }

  //   if (isMaximizing) {
  //     int bestScore = -1000;
  //     for (int i = 0; i < 3; i++) {
  //       for (int j = 0; j < 3; j++) {
  //         if (board.board[i][j] == Player.none) {
  //           board.board[i][j] = Player.o;
  //           int score = _minimax(board, depth + 1, false);
  //           board.board[i][j] = Player.none;
  //           bestScore = score > bestScore ? score : bestScore;
  //         }
  //       }
  //     }
  //     return bestScore;
  //   } else {
  //     int bestScore = 1000;
  //     for (int i = 0; i < 3; i++) {
  //       for (int j = 0; j < 3; j++) {
  //         if (board.board[i][j] == Player.none) {
  //           board.board[i][j] = Player.x;
  //           int score = _minimax(board, depth + 1, true);
  //           board.board[i][j] = Player.none;
  //           bestScore = score < bestScore ? score : bestScore;
  //         }
  //       }
  //     }
  //     return bestScore;
  //   }
  // }
}

// import 'package:flutter/material.dart';
// // import '../models/board.dart';
// import '../models/board_model.dart';
// import '../models/player.dart';

// enum Difficulty { easy, medium, hard }

// class GameViewModel extends ChangeNotifier {
//   final Board board = Board();
//   Difficulty difficulty = Difficulty.easy;
//   Player currentPlayer = Player.x;
//   bool isGameOver = false;

//   void setDifficulty(Difficulty newDifficulty) {
//     difficulty = newDifficulty;
//     resetGame();
//     notifyListeners();
//   }

//   void makeMove(int row, int col) {
//     if (board.board[row][col] != Player.none || isGameOver) return;

//     board.makeMove(row, col, currentPlayer);
//     if (checkGameOver()) return;

//     if (difficulty == Difficulty.hard && currentPlayer == Player.o) {
//       List<int> bestMove = board.getBestMove(Player.o);
//       board.makeMove(bestMove[0], bestMove[1], Player.o);
//       checkGameOver();
//     } else {
//       switchPlayer();
//     }
//   }

//   void switchPlayer() {
//     currentPlayer = currentPlayer == Player.x ? Player.o : Player.x;
//     notifyListeners();
//   }

//   bool checkGameOver() {
//     Player winner = board.getWinner();
//     if (winner != Player.none) {
//       isGameOver = true;
//     } else if (board.isFull()) {
//       isGameOver = true;
//     }

//     notifyListeners();
//     return isGameOver;
//   }

//   void resetGame() {
//     board.resetBoard();
//     currentPlayer = Player.x;
//     isGameOver = false;
//     notifyListeners();
//   }
// }
