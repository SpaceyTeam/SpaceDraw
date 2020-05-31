import 'package:draw/draw_screen.dart';
import 'package:draw/opponent_list_screen.dart';
import 'package:draw/shared/enums.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrawScreen(
                        PlayersMode.One,
                      ),
                    ),
                  );
                },
                child: Text(
                  '1 PLAYER',
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
                      builder: (context) => OpponentListScreen(),
                    ),
                  );
                },
                child: Text(
                  '2 PLAYERS',
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
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(
                  'EXIT',
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
        )
      ],
    );
  }
}
