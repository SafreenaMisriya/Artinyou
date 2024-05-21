import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Imageselect{
  final ImagePicker picker = ImagePicker();

  List<XFile> selectedfile = [];

  FirebaseStorage storageref = FirebaseStorage.instance;

  List<String> arrImage = [];

  int uploaditem = 0;

  bool isuploading = false;
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

    });
    return await reference.getDownloadURL();
  }

  uploadFuction(List<XFile> images) {
    for (int i = 0; i < images.length; i++) {
      var imageUrl = uploading(images[i]);
      arrImage.add(imageUrl.toString());
    }
  }
}
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// // Events
// abstract class ImageEvent {}

// class SelectImageEvent extends ImageEvent {}

// class UploadImageEvent extends ImageEvent {
//   final List<XFile> images;

//   UploadImageEvent(this.images);
// }

// // States
// abstract class ImageState {}

// class ImageInitial extends ImageState {}

// class ImageSelected extends ImageState {
//   final List<XFile> images;

//   ImageSelected(this.images);
// }

// class ImageUploading extends ImageState {}

// class ImageUploaded extends ImageState {
//   final List<String> imageUrls;

//   ImageUploaded(this.imageUrls);
// }

// // BLoC
// class ImageBloc extends Bloc<ImageEvent, ImageState> {
//   final ImagePicker picker = ImagePicker();
//   final FirebaseStorage storageRef = FirebaseStorage.instance;

//   ImageBloc() : super(ImageInitial());

//   @override
//   Stream<ImageState> mapEventToState(ImageEvent event) async* {
//     if (event is SelectImageEvent) {
//       yield* _mapSelectImageToState();
//     } else if (event is UploadImageEvent) {
//       yield* _mapUploadImageToState(event.images);
//     }
//   }

//   Stream<ImageState> _mapSelectImageToState() async* {
//     try {
//       final List<XFile> imgs = await picker.pickMultiImage();
//       if (imgs.isNotEmpty) {
//         yield ImageSelected(imgs);
//       }
//     } catch (e) {
//       throw Exception(e);
//     }
//   }

//   Stream<ImageState> _mapUploadImageToState(List<XFile> images) async* {
//     List<String> imageUrls = [];
//     try {
//       for (int i = 0; i < images.length; i++) {
//         Reference reference = storageRef.ref().child('multiple_image').child(images[i].name);
//         UploadTask uploadTask = reference.putFile(File(images[i].path));
//         await uploadTask.whenComplete(() {
//           // Handle completion
//         });
//         String imageUrl = await reference.getDownloadURL();
//         imageUrls.add(imageUrl);
//       }
//       yield ImageUploaded(imageUrls);
//     } catch (e) {
//       throw Exception(e);
//     }
//   }
// }
