import 'package:flutter_test/flutter_test.dart';
import 'package:connect4_app/logic/game_logic.dart';

void main() {
  //isValidMove
  group('isValidMove', () {
    test('vM1 - empty column is valid', () {
      final board = GameLogic.emptyBoard();
      expect(GameLogic.isValidMove(board, 0), true);
    });

    test('vM2 - full column is invalid', () {
      final board = GameLogic.emptyBoard();
      for (int r = 0; r < GameLogic.rows; r++) {
        board[r][0] = 1;
      }
      expect(GameLogic.isValidMove(board, 0), false);
    });

    test('vM3 - coumn index below 0 is invalid', () {
      final board = GameLogic.emptyBoard();
      expect(GameLogic.isValidMove(board, -1), false);
    });

    test('vM4 - column 7 )out of bounds) is invalid', () {
      final board = GameLogic.emptyBoard();
      expect(GameLogic.isValidMove(board, 7), false);
    });
  });

  //getDropRow
  group('getDropRow', () {
    test('gD1 - disc falls to bottom row in empty column', () {
      final board = GameLogic.emptyBoard();
      expect(GameLogic.getDropRow(board, 3), 5); //Row 5 - bottom
    });

    test('gD2 - disc lands on top of the existing disc', () {
      final board = GameLogic.emptyBoard();
      board[5][3] = 1;
      expect(GameLogic.getDropRow(board, 3), 4);
    });

    test('gD3 - full column returns -1', () {
      final board = GameLogic.emptyBoard();
      for (int r = 0; r < GameLogic.rows; r++) {
        board[r][3] = 1;
      }
      expect(GameLogic.getDropRow(board, 3), -1);
    });
  });

  //checkWin
  group('checkWIn', () {
    test('wC1 - horizontal win detected', () {
      final board = GameLogic.emptyBoard();
      for (int c = 0; c < 4; c++) board[5][c] = 1;
      expect(GameLogic.checkWin(board, 1), true);
    });

    test('wC2 - vertical win detected', () {
      final board = GameLogic.emptyBoard();
      for (int r = 2; r < 6; r++) board[r][3] = 2;
      expect(GameLogic.checkWin(board, 2), true);
    });

    test('wC3 - diagonal down right win detected', () {
      final board = GameLogic.emptyBoard();
      for (int i = 0; i < 4; i++) board[i][i] = 1;
      expect(GameLogic.checkWin(board, 1), true);
    });

    test('wC4 - diagonal down left win detected', () {
      final board = GameLogic.emptyBoard();
      for (int i = 0; i < 4; i++) board[i][3 - i] = 2;
      expect(GameLogic.checkWin(board, 2), true);
    });

    test('wC5 - three in a row is Not a win', () {
      final board = GameLogic.emptyBoard();
      for (int c = 0; c < 3; c++) board[5][c] = 1;
      expect(GameLogic.checkWin(board, 1), false);
    });

    test('wC6 - empty board has no winner for either player', () {
      final board = GameLogic.emptyBoard();
      expect(GameLogic.checkWin(board, 1), false);
      expect(GameLogic.checkWin(board, 2), false);
    });

    test('wC7 - opponent disc in window blocks player win', () {
      final board = GameLogic.emptyBoard();
      board[5][0] = 1;
      board[5][1] = 1;
      board[5][2] = 1;
      board[5][3] = 2; //Opponent blocks the 4th cell
      expect(GameLogic.checkWin(board, 1), false);
    });
  });

  //isDraw
  group('osDraw', () {
    test('dR1 - empty board is not a draw', () {
      final board = GameLogic.emptyBoard();
      expect(GameLogic.isDraw(board), false);
    });

    test('dR2 - fully filled top row counts a draw', () {
      final board = GameLogic.emptyBoard();
      for (int c = 0; c < GameLogic.cols; c++) board[0][c] = 1;
      expect(GameLogic.isDraw(board), false);
    });

    test('dR3 - one empty cell in top row is not a draw', () {
      final board = GameLogic.emptyBoard();
      for (int c = 0; c < GameLogic.cols - 1; c++) board[0][c] = 1;
      expect(GameLogic.isDraw(board), false);
    });
  });

  //applyMove
  group('applyMove', () {
    test('aM1 - disc lands at the bottom of an empty column', () {
      final board = GameLogic.emptyBoard();
      final result = GameLogic.applyMove(board, 3, 1);
      expect(result[5][3], 1);
    });

    test('aM2 - second disc lands directly above first', () {
      var board = GameLogic.emptyBoard();
      board = GameLogic.applyMove(board, 3, 1);
      board = GameLogic.applyMove(board, 3, 2);
      expect(board[5][3], 1);
      expect(board[4][3], 2);
    });

    test('aM3 - original board has not mutated after applyMove', () {
      final board = GameLogic.emptyBoard();
      GameLogic.applyMove(board, 3, 1);
      expect(board[5][3], 0); //original must be unchanged
    });
  });
}
