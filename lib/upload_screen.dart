// assignment module 20 (firebase):
// upload images to firebase storage, and show in gridview
import 'dart:developer';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseStorageAllImageUrlLoad();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Storage Example',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green[100],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.cyan, Colors.indigo],
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
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
                scrollDirection: Axis.vertical,
                //shrinkWrap: true,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          _isLoading==false? Text(
            "Images in firebase Storage= ${urlImageList.length}",
            style: const TextStyle(fontSize: 22),
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
          ),
          const SizedBox(height: 8,),
          ElevatedButton.icon(
            onPressed: (){
              pickCameraImage();
            },
            icon: const Icon(Icons.camera),
            label: const Text('Upload Camera Image',style: TextStyle(fontSize: 20),),
          ),
          const SizedBox(height: 12,),
        ],
      ),
    );
  }

  pickCameraImage()async{
    XFile? pickedFile= await _imagePicker.pickImage(source: ImageSource.camera);
    if(pickedFile!=null){
      uploadToFirebase(File(pickedFile.path)); // <--- image file
    }
  }

  pickGalleryImage()async{
    XFile? pickedFile= await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      uploadToFirebase(File(pickedFile.path)); // <--- image file
    }
  }

  Future<void> uploadToFirebase(image) async{
    _isLoading=true;
    setState(() {});
    Reference storageRef = FirebaseStorage.instance.ref().child("/pictures");
    Reference sr = storageRef.child("/${DateTime.now().millisecondsSinceEpoch}.png");
    try {
      await sr.putFile(image).whenComplete(() => {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded to 🔥Firebase"),
            duration: Duration(seconds: 3),
          ),
        ),
      });
      urlImage = await sr.getDownloadURL(); // String?
      urlImageList.add(urlImage);
    } catch (e) {
      log("error occurred: $e");
    }
    _isLoading=false;
    setState(() {});
  }

  Future<void> firebaseStorageAllImageUrlLoad() async{
    _isLoading=true;
    setState(() {});
    Reference storageRef = FirebaseStorage.instance.ref().child("/pictures");
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      urlImage = await item.getDownloadURL();
      urlImageList.add(urlImage);
    }
    _isLoading=false;
    setState(() {});
  }

}
