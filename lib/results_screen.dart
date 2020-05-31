import 'package:draw/game_mode_screen.dart';
import 'package:draw/play_again_screen.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool resultsProcessed = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        resultsProcessed = true;
      });

      Future.delayed(Duration(seconds: 4)).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PlayAgainScreen(),
          ),
        );
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        resultsProcessed
            ? Container(
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Align(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height,
                    child: FlareActor(
                      'assets/winner_screen.flr',
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      animation: 'Untitled',
                    ),
                  ),
                ),
              )
            : Container(
                child: Align(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FlareActor(
                      'assets/loading_screen.flr',
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      animation: 'check reload',
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
