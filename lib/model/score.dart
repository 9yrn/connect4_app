/// A class to represent the score of a player in a game, including wins, losses, and draws.
class Score {
  final int wins;
  final int losses;
  final int draws;

  const Score({this.wins = 0, this.losses = 0, this.draws = 0});

  Score copyWith({int? wins, int? losses, int? draws}) {
    return Score(
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
    );
  }
}
