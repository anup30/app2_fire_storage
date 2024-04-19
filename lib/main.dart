// firebase storage
// assignment module 20 (firebase):
// upload images to firebase storage, and show in gridview

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:app2_fire_storage/upload_screen.dart';
//import 'package:app2_fire_storage/upload_screen_z.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized(); // <-- for firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const UploadScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          elevation: 3,
          shadowColor: Colors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),),
            backgroundColor: Colors.indigo[500],
            foregroundColor: Colors.green[100],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            elevation: 3,
            //shadowColor: Colors.green,
          ),
        ),
      ),
    );
  }
}