import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/game_view_model.dart';
import '../model/score.dart';
import '../logic/bot_player.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Connect 4',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Human vs Bot',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 48),

              _ScoreCard(score: vm.score),

              const SizedBox(height: 48),
              const Text(
                'Difficulty',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 12),

              _DifficultySelector(
                current: vm.state.difficulty,
                onSelect: (d) =>
                    context.read<GameViewModel>().newGame(difficulty: d),
              ),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    context.read<GameViewModel>().newGame();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GameScreen()),
                    );
                  },
                  child: const Text('Start Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Sub Widgets receive plain data parameter, not the ViewModel.
// This aids in keeping the code reusable and independently testable.

class _ScoreCard extends StatelessWidget {
  final Score score;

  const _ScoreCard({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ScoreStat(
            label: 'Wins',
            value: score.wins,
            color: Colors.greenAccent,
          ),
          _ScoreStat(
            label: 'Losses',
            value: score.losses,
            color: Colors.redAccent,
          ),
          _ScoreStat(
            label: 'Ties',
            value: score.draws,
            color: Colors.yellowAccent,
          ),
        ],
      ),
    );
  }
}

class _ScoreStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _ScoreStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: color,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  final Difficulty current;
  final void Function(Difficulty) onSelect;

  const _DifficultySelector({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Difficulty.values.map((d) {
        final isSelected = d == current;
        final label = d.name[0].toUpperCase() + d.name.substring(1);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected
                    ? Colors.yellow
                    : Colors.transparent,
                foregroundColor: isSelected ? Colors.black87 : Colors.white70,
                side: const BorderSide(color: Colors.white54),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => onSelect(d),
              child: Text(label),
            ),
          ),
        );
      }).toList(),
    );
  }
}
