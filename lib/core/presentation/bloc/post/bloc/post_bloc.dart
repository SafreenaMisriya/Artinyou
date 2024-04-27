import 'dart:io';

import 'package:art_inyou/core/data/model/postmodel.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
    final FirestoreService firestoreService;
       final ImagePicker picker = ImagePicker();
   final FirebaseStorage storageRef = FirebaseStorage.instance;
  PostBloc({required this.firestoreService}) : super(PostInitial()) {
    on< PostAddEvent>((event, emit)async {
    emit(Postloading());
    try {
      await firestoreService.addPost(event.post);
      emit(PostSuccessState());
    } catch (e) {
      emit(PostErrorstate(error: e.toString()));
    }
    });
   on<PostEvent>((event, emit) async {
  if (event is SelectImageEvent || event is UploadImageEvent) {
    if (event is SelectImageEvent) {
      emit(ImageUploading()); 
      try {
        final List<XFile> images = await picker.pickMultiImage();
        if (images.isNotEmpty) {
          emit(ImageSelected(images));
          event = UploadImageEvent(images); 
        } else {
          emit(ImageErrorState(error: 'No images selected.'));
          return; 
        }
      } catch (e) {
        emit(ImageErrorState(error: e.toString()));
        return; 
      }
    }
    final images = (event as UploadImageEvent).images;
    emit(ImageUploading());
    List<String> imageUrls = [];
    try {
      for (final image in images) {
        final reference = storageRef.ref().child('multiple_image').child(image.name);
        final uploadTask = reference.putFile(File(image.path));
        await uploadTask.whenComplete(() {});
        final imageUrl = await reference.getDownloadURL();
        imageUrls.add(imageUrl);
      }
      emit(ImageUploaded(imageUrls));
    } catch (e) {
      emit(ImageErrorState(error: e.toString()));
    }
  }
});
  }
  

}
