import 'dart:io';

import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:art_inyou/core/data/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart'as p;
import 'package:meta/meta.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository chatrepository;
  final FirebaseStorage storageRef = FirebaseStorage.instance;
   final ImagePicker picker = ImagePicker();
  MessageBloc({required this.chatrepository}) : super(MessageInitial()) {
    on<MessageAddEvent>((event, emit) async{
      emit(Messageloading());
    try {
      await chatrepository.sendMessage( event.receiverid,event.userid,event.messages,);
      emit(MessageSuccess());

    } catch (e) {
      emit(MessaggeError(error: e.toString()));
    }
    });
       on<MessageEvent>((event, emit) async {
  if (event is SelectprofileImageEvent || event is UploadprofileImageEvent) {
    if (event is SelectprofileImageEvent) {
      emit(Messageloading()); 
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
          emit(MsgImageSelected([picked!])); 
          event =  UploadprofileImageEvent([picked]); 
        } else {
          emit( MessaggeError(error: 'No image selected.'));
          return; 
        }
      } catch (e) {
        emit(MessaggeError(error: e.toString()));
        return; 
      }
    }
    final image = (event as  UploadprofileImageEvent).images.single; 
    emit(Messageloading());
    try {
      final reference = storageRef.ref().child('message_image').child(image.name); 
      final uploadTask = reference.putFile(File(image.path));
      await uploadTask.whenComplete(() {});
      final imageUrl = await reference.getDownloadURL();
      emit(MsgImageUploaded([imageUrl])); 
    } catch (e) {
      emit(MessaggeError(error: e.toString()));
    }
  }
});

  }
    Future<XFile?>compressImage(String path, int i)async {
   final newpath=  p.join((await getTemporaryDirectory()).path,'${DateTime.now()}.${p.extension(path)}');
   final result= await FlutterImageCompress.compressAndGetFile(path, newpath,quality: i);
   return result;
}

  
}
