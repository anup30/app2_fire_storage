// firebase storage
// assignment module 20 (firebase):
// upload images to firebase storage, and show in gridview

//import 'package:app2_fire_storage/upload_screen_z.dart';
import 'package:app2_fire_storage/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
            //shape: const CircleBorder(),
            backgroundColor: Colors.blue[500],
            foregroundColor: Colors.green[100],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}