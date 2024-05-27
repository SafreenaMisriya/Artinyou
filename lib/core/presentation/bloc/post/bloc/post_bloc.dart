import 'dart:io';
import 'package:art_inyou/core/data/model/commentmodel.dart';
import 'package:art_inyou/core/data/model/likemodel.dart';
import 'package:art_inyou/core/data/model/postmodel.dart';
import 'package:art_inyou/core/data/repository/post_repository.dart';
import 'package:art_inyou/core/domain/likes_fetching.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final FirestoreService firestoreService;
  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storageRef = FirebaseStorage.instance;
  PostBloc({required this.firestoreService}) : super(PostInitial()) {
    on<PostAddEvent>((event, emit) async {
      emit(Postloading());
      try {
        await firestoreService.addPost(event.post);
        emit(PostSuccessState());
      } catch (e) {
        emit(PostErrorstate(error: e.toString()));
      }
    });

    on<PostEditEvent>((event, emit) async {
      emit(Postloading());
      try {
        await firestoreService.updatePost(event.postid, event.post);
        emit(PostEditsuccessState());
      } catch (e) {
        emit(PostErrorstate(error: e.toString()));
      }
    });

    on<PostdeleteEvent>((event, emit) async {
      try {
        await firestoreService.deletePost(event.postid);
        emit(Postdeletesuccessstate());
        emit(Postloading());
      } catch (e) {
        emit(Postdeleteerrorstate(error: e.toString()));
      }
    });
    on<PostCommentEvent>((event, emit) async {
       emit(Postloading());
      try {
        await firestoreService.addcomment(event.comment,event.postid);
       
      } catch (e) {
        emit(PostCommenterrorstate(error: e.toString()));
      }
    });
     on<CommentdeleteEvent>((event, emit) async {
      try {
        await firestoreService.deleteComment(event.postid, event.commentid);
        emit(Postdeletesuccessstate());
        emit(Postloading());
      } catch (e) {
        emit(Postdeleteerrorstate(error: e.toString()));
      }
    });
    // on<PostlikeEvent>((event, emit)async{
    //    emit(Postloading());
    //   try {
    //     await firestoreService.toggleLikePost(event.model, event.postid);
    //      emit(PostedCommentstate());
    //   } catch (e) {
    //       emit(PostCommenterrorstate(error: e.toString()));
    //   }
    // });
        on<PostSearchEvent>((event, emit) async {
       emit(Postloading());
      try {
        QuerySnapshot<Map<String, dynamic>> postsSnapshot =
            await FirebaseFirestore.instance.collection('posts').get();
        List<PostModel>post = postsSnapshot.docs
           .map((doc) => PostModel.fromJson(doc.data(), id: doc.id))
           .where((post) => post.title.toLowerCase().contains(event.value.toLowerCase()) ||
                           post.about.toLowerCase().contains(event.value.toLowerCase()))
           .toList();
        emit(SearchLoaded(post));
      } catch (e) {
        emit(PostSearcherrorstate(error: e.toString()));
      }
    });
    on<LoadPostLikeStatusEvent>((event, emit)async  {
    emit(Postloading());
    try {
      bool liked = await firestoreService. hasUserLikedPost(event.userId, event.postId);
      int count = await getPostLikeCount(event.postId);
      emit(PostLikeStatusLoaded(postId: event.postId, isLiked: liked, likeCount: count));
    } catch (e) {
       emit(Postlikeerrorstate(error: e.toString(),postId: event.postId));
    }
  });

  on<PostlikeEvent>((event, emit)async{
    emit(Postloading());
    try {
      await firestoreService.toggleLikePost(event.model, event.postid);
      bool liked = await firestoreService. hasUserLikedPost(event.model.userid, event.postid);
      int count = await getPostLikeCount(event.postid);
      emit(PostLikeStatusLoaded(postId: event.postid, isLiked: liked, likeCount: count));
    } catch (e) {
      emit(Postlikeerrorstate(error: e.toString(),postId: event.postid));
  }
 } );

    on<PostEvent>((event, emit) async {
      if (event is SelectImageEvent || event is UploadImageEvent) {
        if (event is SelectImageEvent) {
          emit(ImageUploading());
          try {
            final List<XFile> images = await picker.pickMultiImage();
            if (images.isNotEmpty) {
              //  List<XFile> picked = [];
              // for (var image in images) {
              //   var croppedFile = await ImageCropper().cropImage(
              //     sourcePath: image.path,
              //     aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 3),
              //   );
              //   if (croppedFile == null) {
              //     continue;
              //   }
               
              //   XFile? compressedImage =
              //       await compressImage(croppedFile.path, 35);
              //   if (compressedImage != null) {
              //     picked.add(compressedImage);
              //   }
              // }
              //   if (picked.isNotEmpty) {
                  emit(ImageSelected(images));
                  event = UploadImageEvent(images);
               
                  // emit(ImageErrorState(error: 'No images selected.'));
              
              
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
            final reference =
                storageRef.ref().child('multiple_image').child(image.name);
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
  Future<XFile?> compressImage(String path, int i) async {
    final newpath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');
    final result = await FlutterImageCompress.compressAndGetFile(path, newpath,
        quality: i);
    return result;
  }
  


}

