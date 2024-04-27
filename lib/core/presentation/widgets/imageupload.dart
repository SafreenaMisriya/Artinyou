// ignore_for_file: must_be_immutable,, prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageuploadScreen extends StatefulWidget {
  const ImageuploadScreen({super.key});

  @override
  State<ImageuploadScreen> createState() => _ImageuploadScreenState();
}

class _ImageuploadScreenState extends State<ImageuploadScreen> {
  final ImagePicker picker = ImagePicker();

  List<XFile> selectedfile = [];

  FirebaseStorage storageref = FirebaseStorage.instance;

  List<String> arrImage = [];

  int uploaditem = 0;

  bool isuploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isuploading
            ? showloading()
            : Column(
                children: [
                  IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: const Icon(Icons.add_circle)),
                  IconButton(
                      onPressed: () {
                        if (selectedfile.isNotEmpty) {
                          uploadFuction(selectedfile);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please Select Images')));
                        }
                      },
                      icon: const Icon(Icons.upload_file)),
                  Expanded(
                    child: GridView.builder(
                        itemCount: selectedfile.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: ((context, index) {
                          return Image.file(
                            File(
                              selectedfile[index].path,
                            ),
                            fit: BoxFit.cover,
                          );
                        })),
                  )
                ],
              ));
  }
  Widget showloading() {
    return Center(
      child: Column(
        children: [
          Text('Uploading :' +
              uploaditem.toString() +
              "/" +
              selectedfile.length.toString())
        ],
      ),
    );
  }

  Future<void> selectImage() async {
    selectedfile.clear();
    try {
      final List<XFile> imgs = await picker.pickMultiImage();
      if (imgs.isNotEmpty) {
        selectedfile.addAll(imgs);
        uploadFuction(selectedfile);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> uploading(XFile image) async {
    Reference reference =
        storageref.ref().child('multiple image').child(image.name);
    UploadTask uploadTask = reference.putFile(File(image.path));
    await uploadTask.whenComplete(() {
      setState(() {
        uploaditem++;
        if (uploaditem == selectedfile.length) {
          isuploading = false;
          uploaditem = 0;
        }
      });
    });
    return await reference.getDownloadURL();
  }

  uploadFuction(List<XFile> images) {
    setState(() {
      isuploading = true;
    });
    for (int i = 0; i < images.length; i++) {
      var imageUrl = uploading(images[i]);
      arrImage.add(imageUrl.toString());
    }
  }
}
