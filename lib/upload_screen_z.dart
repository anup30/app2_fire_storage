// assignment module 20 (firebase):
// upload images to firebase storage, and show in gridview
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadScreenZ extends StatefulWidget {
  const UploadScreenZ({super.key});

  @override
  State<UploadScreenZ> createState() => _UploadScreenZState();
}

class _UploadScreenZState extends State<UploadScreenZ> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading=false;
  String? urlImage;
  List<String?> urlImageList = [];

  pickCameraImage()async{
    XFile? pickedFile= await _imagePicker.pickImage(source: ImageSource.camera);
    //print("${pickedFile?.name}"); ///
    if(pickedFile!=null){
      uploadToFirebase(File(pickedFile.path)); // <--- image file
    }
  }

  pickGalleryImage()async{
    XFile? pickedFile= await _imagePicker.pickImage(source: ImageSource.gallery);
    //print("${pickedFile?.name}"); ///
    if(pickedFile!=null){
      uploadToFirebase(File(pickedFile.path)); // <--- image file
    }
  }

  uploadToFirebase(image) async{
    _isLoading=true;
    setState(() {});
    try {
      Reference storageRef = FirebaseStorage.instance.ref() //storage Reference
          .child("images/${DateTime.now().millisecondsSinceEpoch}.png"); //also try, create unique id, by uuid package
      // ^ creates new folder in storage if absent
      await storageRef.putFile(image).whenComplete(() => {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded to 🔥Firebase"),
            duration: Duration(seconds: 3),
          ),
        ),
      });
      urlImage = await storageRef.getDownloadURL(); // String?
      urlImageList.add(urlImage);
    } catch (e) {
      log("error occurred: $e");
    }
    _isLoading=false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Storage Example',style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green[100],
          ),
          ),
          backgroundColor: Colors.blue,
          elevation: 3,
          shadowColor: Colors.grey,
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
              "Images added to firebase Storage= ${urlImageList.length}",
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
            const SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }
}
// firebase class 3, see Paginate list results & listAll(): https://firebase.google.com/docs/storage/flutter/list-files#paginate_list_results