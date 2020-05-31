import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:draw/game_mode_screen.dart';
import 'package:draw/results_screen.dart';
import 'package:draw/services/image_service.dart';
import 'package:draw/shared/enums.dart';
import 'package:draw/widgets/countdown_timer.dart';
import 'package:draw/widgets/drawing_painter.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DrawScreen extends StatefulWidget {
  final PlayersMode playersMode;
  final String player2Name;

  DrawScreen(this.playersMode, {this.player2Name});

  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  GameState gameState = GameState.Loading;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List();
  String imageUrl;
  double opacity = 1.0;
  StrokeCap strokeCap = StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.blueAccent,
    Colors.grey,
    Colors.blueGrey,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.greenAccent
  ];

  Future<String> futureImageSearchResult;
  ImageService imageService;

  @override
  void initState() {
    imageService = ImageService();
    futureImageSearchResult = imageService.getImageList();

    super.initState();
  }

  void loadAnotherImage() {
    futureImageSearchResult = imageService.getImageList();
    setState(() {
      points.clear();
      imageUrl = null;
      gameState = GameState.Loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      endDrawer: Drawer(
        child: Container(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.leadPencil,
                      color: selectedColor,
                    ),
                    Expanded(
                      child: Slider(
                        value: strokeWidth,
                        activeColor: selectedColor,
                        inactiveColor: Colors.grey,
                        max: 50.0,
                        min: 0.0,
                        onChanged: (val) {
                          setState(() {
                            strokeWidth = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(8.0),
                  crossAxisCount: 3,
                  children: getColorList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(
                  color: Colors.grey,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: GestureDetector(
              onPanUpdate: (details) {
                if (details.localPosition.dx >
                    MediaQuery.of(context).size.width * 0.7) return;

                setState(() {
                  RenderBox renderBox = context.findRenderObject();
                  points.add(
                    DrawingPoints(
                      points: renderBox.globalToLocal(details.globalPosition),
                      paint: Paint()
                        ..strokeCap = strokeCap
                        ..isAntiAlias = true
                        ..color = selectedColor.withOpacity(opacity)
                        ..strokeWidth = strokeWidth,
                    ),
                  );
                });
              },
              onPanStart: (details) {
                if (gameState != GameState.Playing) return;

                setState(() {
                  RenderBox renderBox = context.findRenderObject();
                  points.add(
                    DrawingPoints(
                      points: renderBox.globalToLocal(details.globalPosition),
                      paint: Paint()
                        ..strokeCap = strokeCap
                        ..isAntiAlias = true
                        ..color = selectedColor.withOpacity(opacity)
                        ..strokeWidth = strokeWidth,
                    ),
                  );
                });
              },
              onPanEnd: (details) {
                setState(() {
                  points.add(null);
                });
              },
              child: Stack(
                children: <Widget>[
                  FutureBuilder<String>(
                    future: futureImageSearchResult,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (imageUrl == null) {
                          imageUrl = snapshot.data;

                          SchedulerBinding.instance.addPostFrameCallback(
                            (_) => setState(
                              () {
                                gameState = GameState.Playing;
                              },
                            ),
                          );
                        }

                        return Opacity(
                          opacity: 0.4,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height,
                          ),
                        );
                      } else
                        return Container(
                          child: Align(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height,
                              child: FlareActor(
                                'assets/loading_screen.flr',
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                                animation: 'TURNING WORLD',
                              ),
                            ),
                          ),
                        );
                    },
                  ),
                  CustomPaint(
                    size: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height,
                    ),
                    painter: DrawingPainter(
                      pointsList: points,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        color: Colors.white,
                        child: widget.playersMode == PlayersMode.Two &&
                                gameState == GameState.Playing
                            ? CountDownTimer(
                                secondsRemaining: 120,
                                whenTimeExpires: () {
                                  setState(() {
                                    gameState = GameState.TimesUp;
                                  });

                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                'Time\'s Up!!!',
                                                style: TextStyle(fontSize: 24),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResultsScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                countDownTimerStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 42.0,
                                    height: 1.2),
                              )
                            : gameState == GameState.Playing
                                ? Container(
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.white,
                                        child: InkWell(
                                          child: IconButton(
                                            iconSize: 64,
                                            onPressed: () {
                                              loadAnotherImage();
                                            },
                                            icon: Icon(
                                              MdiIcons.cached,
                                              color: Colors.blue,
                                              size: 64,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Visibility(
                                    visible:
                                        widget.playersMode == PlayersMode.One &&
                                            points.length > 0,
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.white,
                                        child: InkWell(
                                          child: IconButton(
                                            iconSize: 64,
                                            onPressed: () async {
                                              var data =
                                                  await getUint8ListImage(
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.7),
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height);
                                              await Share.file(
                                                  'SpaceDrawing',
                                                  'spacedrawing.png',
                                                  data,
                                                  'image/png',
                                                  text:
                                                      'Olha só o desenho que eu fiz!');
                                            },
                                            icon: Icon(
                                              Icons.share,
                                              color: Colors.green.shade600,
                                              size: 64,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    replacement: Container(
                                      width: 64,
                                      height: 64,
                                      margin: EdgeInsets.all(
                                        8.0,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: points.length > 0,
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.white,
                                        child: InkWell(
                                          child: IconButton(
                                            iconSize: 64,
                                            onPressed: points.length > 0
                                                ? () {
                                                    setState(() {
                                                      var removeStart =
                                                          points.length > 10
                                                              ? points.length -
                                                                  10
                                                              : 0;

                                                      points.removeRange(
                                                          removeStart,
                                                          points.length);
                                                    });
                                                  }
                                                : null,
                                            icon: Icon(
                                              Icons.undo,
                                              color: points.length > 0
                                                  ? Colors.amber.shade600
                                                  : Theme.of(context)
                                                      .disabledColor,
                                              size: 64,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    replacement: Container(
                                      width: 64,
                                      height: 64,
                                      margin: EdgeInsets.all(
                                        8.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ClipOval(
                                    child: Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        child: IconButton(
                                          iconSize: 64,
                                          onPressed: () {
                                            _drawerKey.currentState
                                                .openEndDrawer();
                                          },
                                          icon: Icon(
                                            MdiIcons.draw,
                                            color: selectedColor,
                                            size: 64,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ClipOval(
                                    child: Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        child: IconButton(
                                          iconSize: 64,
                                          onPressed: () {
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                          'Are you sure?',
                                                          style: TextStyle(
                                                              fontSize: 24),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('YES'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                GameModeScreen(),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text('NO'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            MdiIcons.closeOutline,
                                            color: Colors.red,
                                            size: 64,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getColorList() {
    List<Widget> listWidget = List();
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            child: AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) {
                    pickerColor = color;
                  },
                  enableLabel: true,
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() => selectedColor = pickerColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        child: ClipOval(
          child: Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            height: 36,
            width: 36,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
          ),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedColor = color;
          });
        },
        child: ClipOval(
          child: Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            height: 36,
            width: 36,
            color: color,
          ),
        ),
      ),
    );
  }

  Future<String> getBase64Image(double width, double height) async {
    var rawByteData = await getUint8ListImage(width, height);
    final encoded = base64Encode(rawByteData);
    return encoded;
  }

  Future<Uint8List> getUint8ListImage(double width, double height) async {
    final pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    List<Offset> offsetPoints = List();
    var rect = new Rect.fromLTWH(0.0, 0.0, width, height);
    canvas.clipRect(rect);
    canvas.drawColor(Colors.white, BlendMode.color);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
            points[i].points, points[i + 1].points, points[i].paint);
      } else if (points[i] != null && points[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(points[i].points);
        offsetPoints
            .add(Offset(points[i].points.dx + 0.1, points[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, points[i].paint);
      }
    }

    final image = await pictureRecorder.endRecording().toImage(
          width.floor(),
          height.floor(),
        );

    final rawByteData = await image.toByteData(format: ImageByteFormat.png);

    return rawByteData.buffer
        .asUint8List(rawByteData.offsetInBytes, rawByteData.lengthInBytes);
  }
}
