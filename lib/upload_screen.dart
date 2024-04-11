// assignment module 20 (firebase):
// upload images to firebase storage, and show in gridview
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading=false;
  String? urlImage;
  List<String?> urlImageList = [];

  pickCameraImage()async{
    XFile? res= await _imagePicker.pickImage(source: ImageSource.camera);
    if(res!=null){
      uploadToFirebase(File(res.path)); // <--- image file
    }
  }

  pickGalleryImage()async{
    XFile? res= await _imagePicker.pickImage(source: ImageSource.gallery);
    if(res!=null){
      uploadToFirebase(File(res.path)); // <--- image file
    }
  }

  uploadToFirebase(image) async{
    _isLoading=true;
    setState(() {});
    try {
      Reference sr = FirebaseStorage.instance.ref() //storage Reference
          .child("pictures/${DateTime.now().millisecondsSinceEpoch}.png");
      await sr.putFile(image).whenComplete(() => {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded to 🔥Firebase"),
            duration: Duration(seconds: 3),
          ),
        ),
      });
      urlImage = await sr.getDownloadURL();
    } catch (e) {
      print("error occurred: $e");
    }
    urlImageList.add(urlImage);
    _isLoading=false;
    setState(() {});
  }
  // final elevatedButtonStyleFrom = ElevatedButton.styleFrom(
  //   backgroundColor: Colors.blue[50],
  //   foregroundColor: Colors.green[800],
  //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //   textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
  // );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            _isLoading==false? Text(
              "Total images added to firebase Storage: ${urlImageList.length}",
              style: const TextStyle(fontSize: 20),
            ):
            const Center(
              child: SizedBox(
                height: 30,width: 30,
                child: CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton.icon(
              onPressed: (){
                pickGalleryImage();
              },
              icon: const Icon(Icons.image),
              label: const Text('Upload Gallery Image',style: TextStyle(fontSize: 20),),
              //style: elevatedButtonStyleFrom,
            ),
            const SizedBox(height: 8,),
            ElevatedButton.icon(
              onPressed: (){
                pickCameraImage();
              },
              icon: const Icon(Icons.camera),
              label: const Text('Upload Camera Image',style: TextStyle(fontSize: 20),),
              //style: elevatedButtonStyleFrom,
            ),
            const SizedBox(height: 10,),
            /// gridview
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3,
                ),
                itemBuilder: (context,index) {
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      urlImageList[index]!,
                      fit: BoxFit.contain,
                    ),
                  );
                },
                itemCount: urlImageList.length,
                scrollDirection: Axis.vertical, // vertical, horizontal
              ),
            ),
          ],
        ),
      ),
    );
  }
}
