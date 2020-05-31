import 'package:draw/draw_screen.dart';
import 'package:draw/game_mode_screen.dart';
import 'package:draw/shared/enums.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OpponentListScreen extends StatefulWidget {
  @override
  _OpponentListScreenState createState() => _OpponentListScreenState();
}

class _OpponentListScreenState extends State<OpponentListScreen> {
  TextEditingController _textFieldController = TextEditingController();

  var friendsList = [
    {'status': '1', 'name': 'João Pedro'},
    {'status': '1', 'name': 'Ricardo'},
    {'status': '1', 'name': 'Renatinho'},
    {'status': '0', 'name': 'Luiza'},
    {'status': '0', 'name': 'Ana Eliza'},
    {'status': '0', 'name': 'Dejanira'},
  ];

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add friend'),
            content: TextField(
              controller: _textFieldController,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  setState(() {
                    friendsList.insert(0, {
                      'status': '1',
                      'name': _textFieldController.text,
                    });

                    _textFieldController.text = '';
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 32,
      color: Colors.white,
      shadows: [
        Shadow(
          color: Colors.black,
          offset: Offset(2, 2),
          blurRadius: 3,
        ),
      ],
    );

    return Material(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height - 32,
                  margin: EdgeInsets.all(
                    16.0,
                  ),
                  padding: EdgeInsets.all(
                    16.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Friends',
                        style: textStyle,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 178,
                        child: Material(
                          color: Colors.transparent,
                          child: ListView(
                            shrinkWrap: true,
                            children: friendsList
                                .map(
                                  (e) => ListTile(
                                    leading: Icon(
                                      MdiIcons.circle,
                                      color: e['status'].toString() == '1'
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      size: 16,
                                    ),
                                    dense: true,
                                    title: Text(
                                      e['name'],
                                      style: textStyle.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DrawScreen(
                                            PlayersMode.Two,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  child: IconButton(
                                    iconSize: 32,
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GameModeScreen(),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  child: IconButton(
                                    iconSize: 32,
                                    onPressed: () => _displayDialog(context),
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
