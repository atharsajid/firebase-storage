import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filepicker/Helper/storage_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Storage storage = Storage();
  var results;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Firebase Storage"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                results = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ["pdf", "jpg", "png", "jpeg"],
                );
                setState(() {
                  results = results;
                });

                if (results == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("No File Selected"),
                    ),
                  );
                }
                final pathname = results.files.single.path;
                final filename = results.files.single.name;
                storage.uploadfile(pathname, filename);
              },
              child: Text("Upload File"),
            ),
          ),
          if (results != null) Image.file(File(results.files.single.path)),
        ],
      ),
    ));
  }
}
