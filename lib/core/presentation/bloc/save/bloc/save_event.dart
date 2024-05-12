part of 'save_bloc.dart';

@immutable
sealed class SaveEvent {}
class SavePostEvent extends SaveEvent{
  final String userid;
  final String postid;
  SavePostEvent({required this.postid,required this.userid});
}
class SavedeletePostEvent extends SaveEvent{
  final String userid;
  final String postid;
  SavedeletePostEvent({required this.postid,required this.userid});
}