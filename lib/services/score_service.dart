import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  static const String _winsKey = 'wins';
  static const String _lossesKey = 'losses';
  static const String _drawsKey = 'draws';

  Future<void> recordWin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_winsKey, (prefs.getInt(_winsKey) ?? 0) + 1);
  }

  Future<void> recordLoss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lossesKey, (prefs.getInt(_lossesKey) ?? 0) +1);
  }

  Future<void> recordDraw() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_drawsKey, (prefs.getInt(_drawsKey) ?? 0) +1);
  }

  //Returns all three scores. Defaults to 0 for any key not yet written.
  Future<Map<String, int>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'wins': prefs.getInt(_winsKey) ?? 0,
      'losses': prefs.getInt(_lossesKey) ?? 0,
      'draws': prefs.getInt(_drawsKey) ?? 0,
    };
  }

  Future<void> resetScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_winsKey);
    await prefs.remove(_lossesKey);
    await prefs.remove(_drawsKey);
  }  
}


