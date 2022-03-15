import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(home:MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _scanning = false;
  String _extractText = '';
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text('Tesseract OCR'),
      ),
      body: ListView(
        children: [
          _pickedImage == null
              ? Container(
            height: 300,
            color: Colors.grey[300],
            child: Icon(
              Icons.image,
              size: 100,
            ),
          )
              : Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              // image: DecorationImage(
              //   image: FileImage(_picker),
              //   fit: BoxFit.fill,
              // )
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton(
              color: Colors.green,
              child: Text(
                'Pick Image with text',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                setState(() {
                  _scanning = true;
                });
                _pickedImage = (await _picker.pickImage(source: ImageSource.gallery))!;
                _extractText =
                await FlutterTesseractOcr.extractText(_pickedImage!.path,language: 'eng+ben',
                    args: {
                    "psm": "4",
                    "preserve_interword_spaces": "1",
                    });
                setState(() {
                  _scanning = false;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          _scanning
              ? Center(child: CircularProgressIndicator())
              : Icon(
            Icons.done,
            size: 40,
            color: Colors.green,
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _extractText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

