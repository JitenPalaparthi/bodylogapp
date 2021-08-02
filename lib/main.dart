import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pain Log'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<bool> isSelected = [];
  Offset _offset = Offset(0, 0);
  List<Widget> _positionWidgets = [];
  bool _reload = true;
  Color _color = Colors.red;
  ProblemType _ptype = ProblemType.pain;
  List<ProblemPoint> _problemPoints = [];
  @override
  void initState() {
    isSelected = [true, false, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.hardEdge,
              children: _reload ? addStackList() : _positionWidgets,
            ),
            ToggleButtons(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Iching",
                      style: TextStyle(color: Colors.red, fontSize: 20)),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Pins&Needles",
                      style: TextStyle(color: Colors.blue, fontSize: 20)),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Pain",
                      style: TextStyle(color: Colors.green, fontSize: 20)),
                )
              ],
              borderRadius: BorderRadius.circular(15),
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                  switch (index) {
                    case 0:
                      _color = Colors.red;
                      _ptype = ProblemType.iching;
                      break;
                    case 1:
                      _color = Colors.blue;
                      _ptype = ProblemType.pinsAndNeedles;
                      break;
                    case 2:
                      _color = Colors.green;
                      _ptype = ProblemType.pain;
                      break;
                  }
                });
              },
              isSelected: isSelected,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Log',
        child: Text("Log"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> addStackList() {
    if (_positionWidgets.length == 0) {
      _positionWidgets.add(GestureDetector(
        child: Image.asset(
          'assets/images/male.jpg',
          fit: BoxFit.fill,
          width: 500,
          height: 500,
        ),
        onTapUp: (tp) {
          print("X=" +
              tp.globalPosition.dx.toString() +
              "---------Y=" +
              tp.globalPosition.dy.toString());
          setState(() {
            _reload = true;
            _offset = tp.localPosition;
            _positionWidgets.add(getContainerWidget(_offset, _color));

            _problemPoints.add(
                ProblemPoint(tp.localPosition, _ptype, DateTime.now().toUtc()));
          });
        },
      ));
    }
    return _positionWidgets;
  }

  Widget getContainerWidget(Offset offset, Color color) {
    print("calling------->");
    return Positioned(
        top: offset.dy,
        left: offset.dx,
        child: Container(
          child: CustomPaint(painter: LogPainter(color)),
          color: color,
        ));
  }
}

class LogPainter extends CustomPainter {
  Color _color = Colors.red;
  LogPainter(this._color);
  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = _color;
    //..color = Colors.indigo;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(5, 5, 5, 5), Radius.circular(5)),
      paint,
    );
  }

  @override
  bool shouldRepaint(LogPainter oldDelegate) => false;
}

enum ProblemType { pain, pinsAndNeedles, iching }

class ProblemPoint {
  Offset offset;
  ProblemType problemType;
  DateTime logOn;
  //DateTime starton;
  //DateTime endOn;
  ProblemPoint(this.offset, this.problemType, this.logOn);
}
