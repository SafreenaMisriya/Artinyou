part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}
class SelectprofileImageEvent extends ProfileEvent {
   final bool fromCamera; 
   SelectprofileImageEvent({ this.fromCamera=false});
}

class UploadprofileImageEvent extends ProfileEvent {
  final List<XFile> images;
  UploadprofileImageEvent(this.images);
}
class ProfileAddEvent extends ProfileEvent{
  final ProfileModel model;
  ProfileAddEvent({required this.model});
}
class ProfileEditEvent extends ProfileEvent{
  final ProfileModel model;
  ProfileEditEvent({required this.model,});
}