part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}
class PostAddEvent extends PostEvent{
  final PostModel post;
  PostAddEvent({required this.post});
}
class SelectImageEvent extends PostEvent {}

class UploadImageEvent extends PostEvent {
  final List<XFile> images;

  UploadImageEvent(this.images);
}
class PostEditEvent extends PostEvent{
 
  final String postid;
  final PostModel post;
  PostEditEvent({
  required this.postid,
  required this.post});
}
class PostdeleteEvent extends PostEvent{
  final String postid;
  PostdeleteEvent({required this.postid});
}
