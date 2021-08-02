import 'package:flutter/material.dart';
import 'package:bodylog/models/bodyPoint.dart';
import 'package:bodylog/utils/logPainter.dart';

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
  ProblemType _ptype = ProblemType.Iching;
  List<BodyPoint> _bodyPoints = [];
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
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 300,
                          padding: EdgeInsets.all(5),
                          child: ToggleButtons(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text("Iching",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text("Pins&Needles",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 15)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text("Pain",
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 15)),
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
                                    _ptype = ProblemType.Iching;
                                    break;
                                  case 1:
                                    _color = Colors.blue;
                                    _ptype = ProblemType.PinsAandNeedles;
                                    break;
                                  case 2:
                                    _color = Colors.green;
                                    _ptype = ProblemType.Pain;
                                    break;
                                }
                              });
                            },
                            isSelected: isSelected,
                          )),
                      Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'Log Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ))
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        clipBehavior: Clip.hardEdge,
                        children: _reload ? addStackList() : _positionWidgets,
                      ),
                      Container(
                        // height: 400,
                        // decoration: myBoxDecoration(),
                        child: FutureBuilder(builder: (context, snapshot) {
                          return DataTable(
                            showBottomBorder: true,
                            sortAscending: true,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Number',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Problem Type',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Position',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Log Date Time',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Delete',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: _bodyPoints.map((item) {
                              var index = _bodyPoints.indexOf(item);
                              return DataRow(cells: <DataCell>[
                                DataCell(Text((index + 1).toString())),
                                DataCell(Text(item.problemType
                                    .toShortString()
                                    .toUpperCase())),
                                DataCell(Text(item.offset.dx.toString() +
                                    "-" +
                                    item.offset.dy.toString())),
                                DataCell(Text(item.logOn.toIso8601String())),
                                DataCell(IconButton(
                                  icon: Icon(Icons.delete),
                                  tooltip: "delete entry",
                                  onPressed: () {
                                    setState(() {
                                      _bodyPoints.removeAt(index);
                                      _positionWidgets.removeAt(index + 1);
                                    });
                                    // await onSubmit(
                                    //     context, token, item.id, "inactive");
                                  },
                                )),
                              ]);
                            }).toList(),
                          );
                        }),
                      )
                    ]),

                // Container(
                //   child: FutureBuilder(builder: (context, snapshot) {
                //     return DataTable(
                //       columns: const <DataColumn>[
                //         DataColumn(
                //           label: Text(
                //             'Number',
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //         ),
                //         DataColumn(
                //           label: Text(
                //             'Problem Type',
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //         ),
                //         DataColumn(
                //           label: Text(
                //             'Position',
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //         ),
                //         DataColumn(
                //           label: Text(
                //             'Log Date Time',
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //         ),
                //         DataColumn(
                //           label: Text(
                //             'Delete',
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //         ),
                //       ],
                //       rows: _bodyPoints.map((item) {
                //         var index = _bodyPoints.indexOf(item);
                //         return DataRow(cells: <DataCell>[
                //           DataCell(Text((index + 1).toString())),
                //           DataCell(
                //               Text(item.problemType.toShortString().toUpperCase())),
                //           DataCell(Text(item.offset.dx.toString() +
                //               "-" +
                //               item.offset.dy.toString())),
                //           DataCell(Text(item.logOn.toIso8601String())),
                //           DataCell(IconButton(
                //             icon: Icon(Icons.delete),
                //             tooltip: "delete entry",
                //             onPressed: () {
                //               setState(() {
                //                 _bodyPoints.removeAt(index);
                //                 _positionWidgets.removeAt(index + 1);
                //               });
                //               // await onSubmit(
                //               //     context, token, item.id, "inactive");
                //             },
                //           )),
                //         ]);
                //       }).toList(),
                //     );
                //   }),
                // )
              ],
            ),
          )),

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
          width: 300,
          height: 400,
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

            _bodyPoints.add(
                BodyPoint(tp.localPosition, _ptype, DateTime.now().toUtc()));
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

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }
}
