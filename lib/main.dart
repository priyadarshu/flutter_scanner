import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_scanner/button_widget.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String qrCode = '';
  List<String> item = [];
  //List<String> uniqueItems = [];
  String temp;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Scan Result',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ButtonWidget(
                text: 'Scan QR Code',
                onClicked: () {
                  scanQRCode();
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              qrCode == ''
                  ? Container(
                      height: 0,
                      width: 0,
                    )
                  : Text(
                      'The result is ' + qrCode,
                      style: TextStyle(color: Colors.white54, fontSize: 18.0),
                    ),
              ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: item.length == 0 ? 0 : item.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Text(
                        item[index],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanQRCode() async {
    try {
      qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (item.contains(qrCode)) {
        print('Its repeated');
      } else {
        if (!mounted) return;
        setState(() {
          item.add(qrCode);
        });
      }
    } on PlatformException {
      qrCode = 'Failed to get platform version';
      item = ['no items'];
    } catch (UnsupportedError) {
      UnsupportedError('An unsupported error occured');
    }
  }
}
