import 'game_logic.dart';

class UndoManager {
  final List<List<List<int>>> _history = [];

  //Get a full board snapshot
  //Call once at game start (empty board) and once after every turn
  void push(List<List<int>> board) {
    _history.add(GameLogic.copyBoard(board));
  }

  //Removes the most recent turn and returns the state of the board beofre it.
  //Returns null if there is nothing left to undo (only the initial state remains)
  List<List<int>>? undo() {
    if (_history.length <= 1) return null; //cannot undo past the beginning
    _history.removeLast();
    return GameLogic.copyBoard(_history.last);
  }

  //True when atleast one turn which is complete exists to undo.
  bool get canUndo => _history.length > 1;

  //Clears all history. Called at the start of every new game.
  void clear() => _history.clear();
}
