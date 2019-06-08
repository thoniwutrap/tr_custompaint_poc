import 'package:flutter/material.dart';
import 'package:tr_custompaint_poc/ui/draw_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawScreen(),
    );
  }
}

