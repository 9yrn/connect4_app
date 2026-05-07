import 'package:flutter/foundation.dart';
import 'package:connect4_app/model/game_state.dart';
import 'package:connect4_app/model/score.dart';
import 'package:connect4_app/logic/game_logic.dart';
import 'package:connect4_app/logic/bot_player.dart';
import 'package:connect4_app/logic/undo_manager.dart';
import 'package:connect4_app/services/score_service.dart';

class GameViewModel extends ChangeNotifier {
  //Private State
  late GameState _state;
  Score _score = const Score();

  late AIPlayer _ai;
  final UndoManager _undoManager = UndoManager();
  final ScoreService _scoreService = ScoreService();

  //Constructor
  GameViewModel() {
    _initGame(Difficulty.medium);
    _loadScores();
  }

  //Getters

  GameState get state => _state;
  Score get score => _score;
  bool get isGameOver => _state.status != GameStatus.ongoing;

  String get statusMessage {
    if (_state.isAiThinking) return 'AI is thinking...';
    switch (_state.status) {
      case GameStatus.ongoing:
        return 'Your turn';
      case GameStatus.humanWon:
        return 'You win!';
      case GameStatus.aiWon:
        return 'AI wins!';
      case GameStatus.draw:
        return 'It\'s a draw!';
    }
  }

  //Commands
  Future<void> makeMove(int col) async {
    if (isGameOver || _state.isAiThinking) return;
    if (!GameLogic.isValidMove(_state.board, col)) return;

    // Human Move
    var board = GameLogic.applyMove(_state.board, col, 1);
    _emit(_state.copyWith(board: board));

    if (GameLogic.checkWin(board, 1)) {
      _score = _score.copyWith(wins: _score.wins + 1);
      _emit(_state.copyWith(status: GameStatus.humanWon, canUndo: false));
      await _scoreService.recordWin();
      return;
    }

    if (GameLogic.isDraw(board)) {
      _score = _score.copyWith(draws: _score.draws + 1);
      _emit(_state.copyWith(status: GameStatus.draw, canUndo: false));
      await _scoreService.recordDraw();
      return;
    }

    // AI Move
    _emit(_state.copyWith(isAiThinking: true, canUndo: false));
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate thinking time

    final aiCol = _ai.chooseMove(board);
    if (!GameLogic.isValidMove(board, aiCol)) return;
    board = GameLogic.applyMove(board, aiCol, 2);

    if (GameLogic.checkWin(board, 2)) {
      _score = _score.copyWith(losses: _score.losses + 1);
      _emit(
        _state.copyWith(
          board: board,
          status: GameStatus.aiWon,
          isAiThinking: false,
          canUndo: false,
        ),
      );
      await _scoreService.recordLoss();
      return;
    }

    if (GameLogic.isDraw(board)) {
      _score = _score.copyWith(draws: _score.draws + 1);
      _emit(
        _state.copyWith(
          board: board,
          status: GameStatus.draw,
          isAiThinking: false,
          canUndo: false,
        ),
      );
      await _scoreService.recordDraw();
      return;
    }

    //Full turn completion - snapshot for undo
    _undoManager.push(board);
    _emit(
      _state.copyWith(
        board: board,
        isAiThinking: false,
        canUndo: _undoManager.canUndo,
      ),
    );
  }

  void undoMove() {
    if (!_state.canUndo || _state.isAiThinking) return;
    final previousBoard = _undoManager.undo();
    if (previousBoard != null) {
      _ai.undoMove();
      _emit(
        _state.copyWith(board: previousBoard, canUndo: _undoManager.canUndo),
      );
    }
  }

  void newGame({Difficulty? difficulty}) {
    _initGame(difficulty ?? _state.difficulty);
  }

  //Private Methods
  void _initGame(Difficulty difficulty) {
    final board = GameLogic.createEmptyBoard();
    _ai = AIPlayer(difficulty: difficulty);
    _undoManager.clear();
    _undoManager.push(board); // Initial state for undo
    _emit(
      GameState(
        board: board,
        status: GameStatus.ongoing,
        difficulty: difficulty,
        isAiThinking: false,
        canUndo: false,
      ),
    );
  }

  void _emit(GameState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> _loadScores() async {
    final raw = await _scoreService.getScores();
    _score = Score(
      wins: raw['wins'] ?? 0,
      losses: raw['losses'] ?? 0,
      draws: raw['draws'] ?? 0,
    );
    notifyListeners();
  }
}
