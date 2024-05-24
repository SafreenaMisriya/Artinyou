

// class Imageselect{
//   final ImagePicker picker = ImagePicker();

//   List<XFile> selectedfile = [];

//   FirebaseStorage storageref = FirebaseStorage.instance;

//   List<String> arrImage = [];

//   int uploaditem = 0;

//   bool isuploading = false;
//    Future<void> selectImage() async {
//     selectedfile.clear();
//     try {
//       final List<XFile> imgs = await picker.pickMultiImage();
//       if (imgs.isNotEmpty) {
//         selectedfile.addAll(imgs);
//         uploadFuction(selectedfile);
//       }
//     } catch (e) {
//       throw Exception(e);
//     }
//   }
//    Future<String> uploading(XFile image) async {
//     Reference reference =
//         storageref.ref().child('multiple image').child(image.name);
//     UploadTask uploadTask = reference.putFile(File(image.path));
//     await uploadTask.whenComplete(() {

//     });
//     return await reference.getDownloadURL();
//   }

//   uploadFuction(List<XFile> images) {
//     for (int i = 0; i < images.length; i++) {
//       var imageUrl = uploading(images[i]);
//       arrImage.add(imageUrl.toString());
//     }
//   }
// }
