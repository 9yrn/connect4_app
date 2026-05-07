import 'dart:math';
import 'game_logic.dart';

enum Difficulty { easy, medium, hard }

class AIPlayer {
  final Difficulty difficulty;
  int _moveCount =
      0; //Tracks total moves made by bot - used for Medium alternation
  final Random _random = Random();

  AIPlayer({required this.difficulty});

  ///Primary entry point. Returns the AI's chosen column index
  ///Increases internal move counter after each call
  int chooseMove(List<List<int>> board) {
    final int col;
    switch (difficulty) {
      case Difficulty.easy:
        col = _easyMove(board);
        break;
      case Difficulty.medium:
        col = _mediumMove(board);
        break;
      case Difficulty.hard:
        col = _hardMove(board);
        break;
    }
    _moveCount++;
    return col;
  }

  ///Call when a turn is undoneto keep the move counter precise.
  ///Without this, Medium difficulty alternation breaks after an undo.
  void undoMove() {
    if (_moveCount > 0) _moveCount--;
  }

  //Resets the internal state for a new game
  void reset() => _moveCount = 0;

  //Easy - Always random (no strategy)
  int _easyMove(List<List<int>> board) {
    return _randomColumn(board);
  }

  //Medium - first move random, then alternates with hard
  int _mediumMove(List<List<int>> board) {
    if (_moveCount == 0) return _randomColumn(board);
    return _moveCount.isOdd ? _hardMove(board) : _randomColumn(board);
  }

  //Hard - follows Provided Pseudocode exactly, step by step.

  int _hardMove(List<List<int>> board) {
    const int ai = 2;
    const int human = 1;
    const int centerCol = 3;

    final valid = GameLogic.validColumns(board);

    //Step 1 - Take the win immediately if available
    for (final col in valid) {
      final next = GameLogic.applyMove(board, col, ai);
      if (GameLogic.checkWin(next, ai)) return col;
    }

    //Step 2 - Block the opponents immediate win
    for (final col in valid) {
      final next = GameLogic.applyMove(board, col, human);
      if (GameLogic.checkWin(next, human)) return col;
    }

    //Step 3 - Creates a 3 in a row with a reachable winning opportuniy
    for (final col in valid) {
      if (GameLogic.createsThreeWithOpportunity(board, col, ai)) return col;
    }

    //Step 4 - Prefer the center column
    if (valid.contains(centerCol)) return centerCol;

    //Step 5 - Prefer columns adjacent to center
    for (final col in [centerCol - 1, centerCol + 1]) {
      if (valid.contains(col)) return col;
    }

    //Step 6 - Any reamining valid column
    return valid[_random.nextInt(valid.length)];
  }

  int _randomColumn(List<List<int>> board) {
    final valid = GameLogic.validColumns(board);
    return valid[_random.nextInt(valid.length)];
  }
}
