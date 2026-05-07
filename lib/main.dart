import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model/game_view_model.dart';
import 'view/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameViewModel(),
      child: const Connect4App(),
    ),
  );
}

class Connect4App extends StatelessWidget {
  const Connect4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect 4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
