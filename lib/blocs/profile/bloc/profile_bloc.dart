import 'dart:async';
import 'dart:io';
import 'package:art_inyou/models/model/profilemodel.dart';
import 'package:art_inyou/repositories/profile/profile_repository.dart';
import 'package:art_inyou/repositories/search/search_profile.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart'as p;
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Profilestorage firestoreService;
   final ImagePicker picker = ImagePicker();
   final FirebaseStorage storageRef = FirebaseStorage.instance;
  ProfileBloc({required this.firestoreService}) : super(ProfileInitial()) {
    
   on<ProfileEvent>((event, emit) async {
  if (event is SelectprofileImageEvent || event is UploadprofileImageEvent) {
    if (event is SelectprofileImageEvent) {
      emit(Profileloading()); 
      try {
        XFile? image;
        if (event.fromCamera) {
          image = await picker.pickImage(source: ImageSource.camera);
        } else {
          image = await picker.pickImage(source: ImageSource.gallery);
        }
        
        if (image != null) {
          var file=  await ImageCropper().cropImage(sourcePath: image.path,aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
          if(file ==null){
            return;
          }
          XFile?  picked= await compressImage(file.path,35);
          emit(ImageSelected([picked!])); 
          event =  UploadprofileImageEvent([picked]); 
        } else {
          emit( Profileerrorstate(error: 'No image selected.'));
          return; 
        }
      } catch (e) {
        emit( Profileerrorstate(error: e.toString()));
        return; 
      }
    }
    final image = (event as  UploadprofileImageEvent).images.single; 
    emit(Profileloading());
    try {
      final reference = storageRef.ref().child('single_image').child(image.name); 
      final uploadTask = reference.putFile(File(image.path));
      await uploadTask.whenComplete(() {});
      final imageUrl = await reference.getDownloadURL();
      emit(ImageUploaded([imageUrl])); 
    } catch (e) {
      emit( Profileerrorstate(error: e.toString()));
    }
  }
});

 on<ProfileAddEvent>((event, emit)async {
    emit(Profileloading());
    try {
       firestoreService.addprofile(event.model);
      emit(Profileaddstate());
      
     
    } catch (e) {
      emit(Profileerrorstate(error: e.toString()));
    }
    });
       on<FollowEvent>((event, emit)async{
    emit(Profileloading());
    try {
      await firestoreService.followUser(event.otheruserid);
      emit(Followaddstate());
      add(CheckfollowStatusEvent(otheruserid: event.otheruserid));
       
    } catch (e) {
      emit(ProfileEditError(error: e.toString()));
    }
   });
    on<UnFollowEvent>((event, emit)async{
    emit(Profileloading());
    try {
      await firestoreService.unfollowUser(event.otheruserid);
      emit(UnFollowaddstate());
       add(CheckfollowStatusEvent(otheruserid: event.otheruserid));
       
    } catch (e) {
      emit(ProfileEditError(error: e.toString()));
    }
   });
   on<CheckfollowStatusEvent>((event, emit)async{
   bool isfollowing= await firestoreService.checkIfFollowing(event.otheruserid);
    emit(isfollowing? FollowingStatusState(true) : FollowingStatusState(false));
   });

   on<ProfileEditEvent>((event, emit)async{ 
    emit(Profileloading());
    try {
       firestoreService.updateProfile(event.model);
      emit(ProfileEditState());
       
    } catch (e) {
      emit(ProfileEditError(error: e.toString()));
    }
   });
   on<ProfileSearchEvent>((event, emit)async{
     emit(Searchstart());
     try {
    final filtered= getFilteredProfiles(event.profiles, event.searchword);
     emit(SearchLoaded(filtered) );

     } catch (e) {
       emit(SearchErrorstate(error: e.toString()));
     }
   });



  }
  Future<XFile?>compressImage(String path, int i)async {
   final newpath=  p.join((await getTemporaryDirectory()).path,'${DateTime.now()}.${p.extension(path)}');
   final result= await FlutterImageCompress.compressAndGetFile(path, newpath,quality: i);
   return result;
}



}

