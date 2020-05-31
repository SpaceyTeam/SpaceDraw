import 'package:draw/game_mode_screen.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class PlayAgainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Container(
            child: Align(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FlareActor(
                  'assets/loading_screen.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  animation: 'falling stars',
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: Text(
                    'PLAY AGAIN?',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameModeScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'YES',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(2, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameModeScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'NO',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(2, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
