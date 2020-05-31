import 'package:draw/draw_screen.dart';
import 'package:draw/game_mode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(DrawApp());

class DrawApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      //DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameModeScreen(),
    );
  }
}
