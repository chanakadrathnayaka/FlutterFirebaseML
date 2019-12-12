import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find Visa Offers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Find Visa Offers'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SlidingUpPanel(
        panel:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: data.map((d) => Text(d)).toList(),
              ),
            ),
          ],
        ),
        body: Center(
          child: Text("This is the Widget behind the sliding panel"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final barcode = await Navigator.of(context).push<Barcode>(
            MaterialPageRoute(
              builder: (c) {
                return ScanPage();
              },
            ),
          );
          if (barcode == null) {
            return;
          }

          setState(() {
            data.add(barcode.displayValue);
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool resultSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: CameraMlVision<List<Barcode>>(
            detector: FirebaseVision.instance
                .barcodeDetector()
                .detectInImage,
            onResult: (List<Barcode> barcodes) {
              if (!mounted || resultSent) {
                return;
              }
              resultSent = true;
              Navigator.of(context).pop<Barcode>(barcodes.first);
            },
          ),
        ),
      ),
    );
  }
}