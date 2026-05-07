import 'package:flutter/material.dart';
import '../logic/game_logic.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  final List<List<int>> board;
  final ValueChanged<int> onColumnTap;
  final bool enabled;

  const BoardWidget({
    super.key,
    required this.board,
    required this.onColumnTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: GameLogic.cols / GameLogic.rows,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0D47A1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: GameLogic.cols,
          ),
          itemCount: GameLogic.rows * GameLogic.cols,
          itemBuilder: (context, index) {
            final row = index ~/ GameLogic.cols;
            final col = index % GameLogic.cols;
            return GestureDetector(
              onTap: enabled ? () => onColumnTap(col) : null,
              child: CellWidget(value: board[row][col]),
            );
          },
        ),
      ),
    );
  }
}
