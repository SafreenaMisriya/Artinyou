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
class ProfileSearchEvent extends ProfileEvent{
    final List<ProfileModel> profiles;
    final String searchword;
ProfileSearchEvent(this.profiles,this.searchword);
}
class ProfileChatSearchEvent extends ProfileEvent{
    final List<ProfileModel> profiles;
    final String searchword;
ProfileChatSearchEvent(this.profiles,this.searchword);
}
class FollowEvent extends ProfileEvent{
  final String otheruserid;
  FollowEvent({required this.otheruserid,});
}
class UnFollowEvent extends ProfileEvent{
  final String otheruserid;
  UnFollowEvent({required this.otheruserid,});
}
class CheckfollowStatusEvent extends ProfileEvent{
  final String otheruserid;
  CheckfollowStatusEvent({required this.otheruserid});
}
