import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Base64 Image Display')),
        body: FutureBuilder<Uint8List?>(
          future: _loadAndDecodeImage(),
          builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              if (snapshot.hasData) {
                return Image.memory(snapshot.data!);
              } else {
                return Text("No image data found");
              }
            }
          },
        ),
      ),
    );
  }

  Future<Uint8List?> _loadAndDecodeImage() async {
    String base64Data;
    try {
      base64Data = await rootBundle.loadString('assets/image/ku-logo.txt');
      base64Data = base64Data.trim().replaceAll(RegExp(r'\n|\s'), '');
      print("Base64 data (after cleaning): $base64Data");
    } catch (error) {
      print("Error loading asset: $error");
      return null;
    }

    try {
      List<String> parts = base64Data.split(',');
      if (parts.length != 2) {
        throw FormatException("Invalid data URI format");
      }
      return base64Decode(parts[1]);
    } catch (error) {
      print("Error decoding base64: $error");
      return null;
    }
  }
}
