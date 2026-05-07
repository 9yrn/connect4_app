class GameLogic {
  static const int rows = 6;
  static const int cols = 7;

  /// Board Convention:
  ///   board[0][0] = top-left cell
  ///   board[5][6] = bottom-right cell
  ///   0 = empty, 1 = human player, 2 = AI player

  //Creates a new empty 6x7 board
  static List<List<int>> emptyBoard() {
    return List.generate(rows, (_) => List.filled(cols, 0));
  }

  static List<List<int>> createEmptyBoard() => emptyBoard();

  //Returns a deep copy of the board so mutations never affect the orignal.
  static List<List<int>> copyBoard(List<List<int>> board) {
    return board.map((row) => List<int>.from(row)).toList();
  }

  //A move is allowed if the column exists and its top cell is empty
  //Checking only the top cell is enough (if it is empty, there's space)

  static bool isValidMove(List<List<int>> board, int col) {
    if (col < 0 || col >= cols) return false;
    return board[0][col] == 0;
  }

  //Finds the lowest empty row in a column (wherethe disc wil end up)
  //Returns -1 if the column is full (should not occur after isValidMove check)
  static int getDropRow(List<List<int>> board, int col) {
    for (int r = rows - 1; r >= 0; r--) {
      if (board[r][col] == 0) return r;
    }
    return -1;
  }

  //Returns a new board with the disc placed. Never mutates the original.
  static List<List<int>> applyMove(List<List<int>> board, int col, int player) {
    final newBoard = copyBoard(board);
    final row = getDropRow(newBoard, col);
    if (row != -1) newBoard[row][col] = player;
    return newBoard;
  }

  //Returns all column indices that still have at least one empty cell
  static List<int> validColumns(List<List<int>> board) {
    return List.generate(
      cols,
      (c) => c,
    ).where((col) => isValidMove(board, col)).toList();
  }

  //Checks all four win directions for the player
  static bool checkWin(List<List<int>> board, int player) {
    //Horizontal
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c <= cols - 4; c++) {
        if (board[r][c] == player &&
            board[r][c + 1] == player &&
            board[r][c + 2] == player &&
            board[r][c + 3] == player) {
          return true;
        }
      }
    }

    //Vertical
    for (int c = 0; c < cols; c++) {
      for (int r = 0; r <= rows - 4; r++) {
        if (board[r][c] == player &&
            board[r + 1][c] == player &&
            board[r + 2][c] == player &&
            board[r + 3][c] == player) {
          return true;
        }
      }
    }

    //Diagonal down right
    for (int r = 0; r <= rows - 4; r++) {
      for (int c = 0; c <= cols - 4; c++) {
        if (board[r][c] == player &&
            board[r + 1][c + 1] == player &&
            board[r + 2][c + 2] == player &&
            board[r + 3][c + 3] == player) {
          return true;
        }
      }
    }

    //Diagonal down left
    for (int r = 0; r <= rows - 4; r++) {
      for (int c = 3; c < cols; c++) {
        if (board[r][c] == player &&
            board[r + 1][c - 1] == player &&
            board[r + 2][c - 2] == player &&
            board[r + 3][c - 3] == player) {
          return true;
        }
      }
    }

    return false;
  }

  //A draw occurs when al 42 cells are filled with no winner
  //Only the top row is required to be checked (if full, the whole board is full).
  static bool isDraw(List<List<int>> board) {
    return board[0].every((cell) => cell != 0);
  }

  //Returns true if placed in [col], creates 3 in a row with reachable
  //4th cell still available. Used by Hard AI at Step 3 of the pseudocode 1.
  static bool createsThreeWithOpportunity(
    List<List<int>> board,
    int col,
    int player,
  ) {
    final row = getDropRow(board, col);
    if (row == -1) return false;

    final newBoard = copyBoard(board);
    newBoard[row][col] = player;
    return _hasLiveThreat(newBoard, player);
  }

  //Scans all windows of 4 cells across all directions
  static bool _hasLiveThreat(List<List<int>> board, int player) {
    final directions = [
      [0, 1], // Horizontal
      [1, 0], // Vertical
      [1, 1], // Diagonal down right
      [1, -1], // Diagonal down left
    ];

    for (final dir in directions) {
      final dr = dir[0];
      final dc = dir[1];

      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          int playerCount = 0;
          int emptyRow = -1;
          int emptyCol = -1;
          bool windowValid = true;

          for (int i = 0; i < 4; i++) {
            final nr = r + dr * i;
            final nc = c + dc * i;

            if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) {
              windowValid = false;
              break;
            }

            if (board[nr][nc] == player) {
              playerCount++;
            } else if (board[nr][nc] == 0) {
              emptyRow = nr;
              emptyCol = nc;
            } else {
              //Opponent disc blocks this window fully
              windowValid = false;
              break;
            }
          }

          if (!windowValid) continue;

          //Live threat: 3 discs, 1 empty cell, and that cell is reachable
          if (playerCount == 3 && emptyRow != -1) {
            if (isValidMove(board, emptyCol) &&
                getDropRow(board, emptyCol) == emptyRow) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }
}
