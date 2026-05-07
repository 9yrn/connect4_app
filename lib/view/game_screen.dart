import 'package:connect4_app/model/game_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/game_view_model.dart';
import '../model/score.dart';
import '../widget/board_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();
    final state = vm.state;

    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text("Connect 4", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: "Undo Last Turn",
            onPressed: vm.state.canUndo
                ? () => context.read<GameViewModel>().undoMove()
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "New Game",
            onPressed: () => context.read<GameViewModel>().newGame(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          _InGameScore(score: vm.score),

          const SizedBox(height: 16),

          //vm.statusMessage is computed in the ViewModel (View just displays it).
          Text(
            vm.statusMessage,
            style: TextStyle(
              color: _statusColor(vm.state.status, vm.state.isAiThinking),
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: BoardWidget(
              board: state.board,
              enabled: !vm.isGameOver && !state.isAiThinking,
              onColumnTap: vm.makeMove,
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Color _statusColor(GameStatus status, bool isAiThinking) {
    if (isAiThinking) return Colors.white70;
    switch (status) {
      case GameStatus.ongoing:
        return Colors.white;
      case GameStatus.humanWon:
        return Colors.greenAccent;
      case GameStatus.aiWon:
        return Colors.redAccent;
      case GameStatus.draw:
        return Colors.amberAccent;
    }
  }
}

class _InGameScore extends StatelessWidget {
  final Score score;

  const _InGameScore({required this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Chip(label: 'W: ${score.wins}', color: Colors.greenAccent),
        const SizedBox(width: 12),
        _Chip(label: 'L: ${score.losses}', color: Colors.redAccent),
        const SizedBox(width: 12),
        _Chip(label: 'D: ${score.draws}', color: Colors.white60),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
