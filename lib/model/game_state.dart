import 'package:connect4_app/logic/bot_player.dart';

enum GameStatus { ongoing, humanWon, aiWon, draw }

// Represents the current state of the game, including the board configuration, game status, difficulty level, and whether the AI is currently thinking.
class GameState {
  final List<List<int>> board;
  final GameStatus status;
  final Difficulty difficulty;
  final bool isAiThinking;
  final bool canUndo;

  const GameState({
    required this.board,
    required this.status,
    required this.difficulty,
    required this.isAiThinking,
    required this.canUndo,
  });

  GameState copyWith({
    List<List<int>>? board,
    GameStatus? status,
    Difficulty? difficulty,
    bool? isAiThinking,
    bool? canUndo,
  }) {
    return GameState(
      board: board ?? this.board,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      isAiThinking: isAiThinking ?? this.isAiThinking,
      canUndo: canUndo ?? this.canUndo,
    );
  }
}
