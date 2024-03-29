import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tr_custompaint_poc/customwidget/drawing_widget.dart';
import 'package:tr_custompaint_poc/model/drawing_points.dart';

class DrawScreen extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<DrawScreen> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List();
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.round : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
  Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("TR DRAW-POC",style: TextStyle(
          color: Colors.grey[700]
        ),),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.album),
                            onPressed: () {
                              setState(() {
                                if (selectedMode == SelectedMode.StrokeWidth)
                                  showBottomList = !showBottomList;
                                selectedMode = SelectedMode.StrokeWidth;
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.color_lens),
                            onPressed: () {
                              setState(() {
                                if (selectedMode == SelectedMode.Color)
                                  showBottomList = !showBottomList;
                                selectedMode = SelectedMode.Color;
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                showBottomList = false;
                                points.clear();
                              });
                            }),
                      ],
                    ),
                    Visibility(
                      child: (selectedMode == SelectedMode.Color)
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: getColorList(),
                      )
                          : Slider(
                          value: (selectedMode == SelectedMode.StrokeWidth)
                              ? strokeWidth
                              : opacity,
                          max: (selectedMode == SelectedMode.StrokeWidth)
                              ? 50.0
                              : 1.0,
                          min: 0.0,
                          onChanged: (val) {
                            setState(() {
                              if (selectedMode == SelectedMode.StrokeWidth)
                                strokeWidth = val;
                              else
                                opacity = val;
                            });
                          }),
                      visible: showBottomList,
                    ),
                  ],
                ),
              )),
        ),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(DrawingPoints(
                points: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanStart: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(DrawingPoints(
                points: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawingPainter(
            pointsList: points,
          ),
        ),
      ),
    );
  }

  getColorList() {
    List<Widget> listWidget = List();
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          child: AlertDialog(
            title: const Text('เลือกซะ'),
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
                child: const Text('ตกลง'),
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
                colors: [Colors.red, Colors.green, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
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
    );
  }
}


enum SelectedMode { StrokeWidth, Opacity, Color }