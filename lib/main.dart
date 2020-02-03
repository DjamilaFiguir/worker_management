//flutter run -d web-server
import 'package:flutter/material.dart';
import 'Screen/workers_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //primarySwatch: Colors.bl,
        hoverColor: Color.fromARGB(220, 0, 175, 201),
        
      ),
      debugShowCheckedModeBanner: false,
      home: WorkerList(),
    );
  }
}
