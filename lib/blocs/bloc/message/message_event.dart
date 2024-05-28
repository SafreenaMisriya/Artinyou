// ignore_for_file: must_be_immutable

part of 'message_bloc.dart';

@immutable
sealed class MessageEvent {}
class MessageAddEvent extends MessageEvent{
  final String userid;
  final String receiverid;
   final MessageModel messages;
 MessageAddEvent({required this.messages,required this.receiverid,required this.userid});
}
class SelectprofileImageEvent extends MessageEvent {
   final bool fromCamera; 
   SelectprofileImageEvent({ this.fromCamera=false});
}

class UploadprofileImageEvent extends MessageEvent {
  final List<XFile> images;
  UploadprofileImageEvent(this.images);
}