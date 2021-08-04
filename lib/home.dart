import 'package:flutter/material.dart';
import 'package:bodylog/models/bodyPoint.dart';
//import 'package:bodylog/utils/logPainter.dart';
import 'package:intl/intl.dart'; // for date format
//import 'package:intl/date_symbol_data_local.dart'; // for other locales

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<bool> isSelected = [];
  Offset _offset = Offset(0, 0);
  final List<Widget> _positionWidgets = [];
  bool _reload = true;
  bool _isSwitched = true;
  Color _color = Colors.red;
  ProblemType _ptype = ProblemType.Iching;
  List<BodyPoint> _bodyPoints = [];

  DateTime _date = DateTime.now();
  TimeOfDay _time =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  DateTime _startdate = DateTime.now();
  TimeOfDay _starttime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
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
                        child: Row(children: [
                          Text("Lock:", style: TextStyle(fontSize: 15)),
                          Switch(
                            value: _isSwitched,
                            onChanged: (value) {
                              setState(() {
                                _isSwitched = value;
                                print(_isSwitched);
                              });
                            },
                            activeTrackColor: Colors.yellow,
                            activeColor: Colors.orangeAccent,
                          )
                        ]),
                      ),
                      Container(
                          // width: 250,
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
                          padding: EdgeInsets.only(left: 30),
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
                        padding: EdgeInsets.only(left: 30),
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
                                  'Description',
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
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text((index + 1).toString())),
                                  DataCell(Text(item.problemType
                                      .toShortString()
                                      .toUpperCase())),
                                  DataCell(Text(item.offset.dx.toString() +
                                      "-" +
                                      item.offset.dy.toString())),
                                  DataCell(Text(item.description)),
                                  DataCell(Text(
                                      DateFormat('yyyy-MM-dd hh:mm:ss')
                                          .format(item.logOn))),
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
                                ],
                              );
                            }).toList(),
                          );
                        }),
                      )
                    ]),
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
          if (_isSwitched) {
            print("X=" +
                tp.localPosition.dx.toString() +
                "---------Y=" +
                tp.localPosition.dy.toString());
            setState(() {
              UniqueKey _someKey = UniqueKey();
              _reload = true;
              _offset = tp.localPosition;
              _positionWidgets
                  .add(getContainerWidget(_someKey, _offset, _color));

              _bodyPoints.add(BodyPoint(
                  _someKey,
                  tp.localPosition,
                  _ptype,
                  DateTime.now().toUtc(),
                  "",
                  DateTime.now().toUtc(),
                  DateTime.now().add(const Duration(hours: 1)).toUtc()));
            });
          }
        },
      ));
    }
    return _positionWidgets;
  }

  Widget getContainerWidget(UniqueKey somekey, Offset offset, Color color) {
    return Positioned(
        key: somekey,
        top: offset.dy,
        left: offset.dx,
        child: GestureDetector(
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          onTapUp: (tp) {
            //print(somekey.toString());
            TextEditingController tc = TextEditingController();
            int widindex = -1; // current widget index
            int pointindex = -1; // current body point index
            for (int i = 0; i < _positionWidgets.length; i++) {
              if (_positionWidgets[i].key == somekey) {
                widindex = i;
                break;
              }
            }
            for (int i = 0; i < _bodyPoints.length; i++) {
              if (_bodyPoints[i].key == somekey) {
                pointindex = i;
                break;
              }
            }
            if (!_isSwitched) {
              final RenderBox overlay =
                  Overlay.of(context)!.context.findRenderObject() as RenderBox;
              showMenu(
                  context: context,
                  position: RelativeRect.fromRect(
                      tp.globalPosition &
                          Size(40, 40), // smaller rect, the touch area
                      Offset.zero & overlay.size),
                  items: [
                    PopupMenuItem<int>(
                        value: 0,
                        child: Container(
                            child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'No Problem Date&Time',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        child: Text(DateFormat('yyyy-MM-dd')
                                            .format(_date)),
                                        onPressed: () async {
                                          final DateTime newDate =
                                              await showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime.now()
                                                        .add(const Duration(
                                                            days: -100)),
                                                    lastDate: DateTime.now()
                                                        .add(const Duration(
                                                            days: 100)),
                                                    initialDate: DateTime.now(),
                                                    helpText: 'Select a date',
                                                  ) ??
                                                  DateTime.now();

                                          setState(() {
                                            _date = newDate;
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: Text('${_time.format(context)}'),
                                        onPressed: () async {
                                          final TimeOfDay newTime =
                                              await showTimePicker(
                                                    context: context,
                                                    initialTime: _time,
                                                  ) ??
                                                  TimeOfDay(
                                                      hour: DateTime.now().hour,
                                                      minute: DateTime.now()
                                                          .minute);

                                          setState(() {
                                            _time = newTime;
                                          });
                                        },
                                      )
                                    ])))),
                    PopupMenuItem<int>(
                        value: 1,
                        child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                                child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Problem Started Date&Time',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          TextButton(
                                            child: Text(DateFormat('yyyy-MM-dd')
                                                .format(_startdate)),
                                            onPressed: () async {
                                              final DateTime newDate =
                                                  await showDatePicker(
                                                        context: context,
                                                        firstDate:
                                                            DateTime.now().add(
                                                                const Duration(
                                                                    days:
                                                                        -100)),
                                                        lastDate: DateTime.now()
                                                            .add(const Duration(
                                                                days: 100)),
                                                        initialDate:
                                                            DateTime.now(),
                                                        helpText:
                                                            'Select a date',
                                                      ) ??
                                                      DateTime.now();

                                              setState(() {
                                                _startdate = newDate;
                                              });
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                                '${_starttime.format(context)}'),
                                            onPressed: () async {
                                              final TimeOfDay newTime =
                                                  await showTimePicker(
                                                        context: context,
                                                        initialTime: _time,
                                                      ) ??
                                                      TimeOfDay(
                                                          hour: DateTime.now()
                                                              .hour,
                                                          minute: DateTime.now()
                                                              .minute);

                                              setState(() {
                                                _starttime = newTime;
                                              });
                                            },
                                          )
                                        ]))))),
                    PopupMenuItem<int>(
                      value: 1,
                      child: TextField(
                        controller: tc,
                        decoration: InputDecoration(
                          labelText: 'Log Description',
                          border: InputBorder.none,
                          hintText: 'Describe this log',
                          enabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide()),
                        ),
                      ),
                    ),
                    PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              OutlinedButton(
                                child: Text("Save"),
                                onPressed: () {
                                  setState(() {
                                    _bodyPoints[pointindex].description =
                                        tc.text;
                                  });
                                },
                              ),
                              OutlinedButton(
                                  child: Text("Delete"),
                                  onPressed: () {
                                    if (widindex >= 0) {
                                      setState(() {
                                        _positionWidgets.removeAt(widindex);
                                        _bodyPoints.removeAt(pointindex);
                                      });
                                    }
                                  }),
                            ])),
                  ]);
            }
          },
        ));
  }
}
