import 'dart:io';
import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
          emit(ImageSelected([image])); 
          event =  UploadprofileImageEvent([image]); 
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
      await firestoreService.addprofile(event.model);
      emit(Profileaddstate());
      
     
    } catch (e) {
      emit(Profileerrorstate(error: e.toString()));
    }
    });

   on<ProfileEditEvent>((event, emit)async{
    emit(Profileloading());
    try {
      await firestoreService.updateProfile(event.model);
      emit(ProfileEditState());
       
    } catch (e) {
      emit(ProfileEditError(error: e.toString()));
    }
   }); 

  }
}
