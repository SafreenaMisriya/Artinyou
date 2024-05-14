part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

class PostAddEvent extends PostEvent {
  final PostModel post;
  PostAddEvent({required this.post});
}

class SelectImageEvent extends PostEvent {}

class UploadImageEvent extends PostEvent {
  final List<XFile> images;

  UploadImageEvent(this.images);
}

class PostEditEvent extends PostEvent {
  final String postid;
  final PostModel post;
  PostEditEvent({required this.postid, required this.post});
}

class PostdeleteEvent extends PostEvent {
  final String postid;
  PostdeleteEvent({required this.postid});
}

class PostCommentEvent extends PostEvent {
  final String postid;
  final CommentModel comment;
  PostCommentEvent({required this.postid, required this.comment});
}
class PostlikeEvent extends PostEvent{
  final String postid;
  final LikeModel model;
  PostlikeEvent({required this.model,required this.postid});
}
class CommentdeleteEvent extends PostEvent {
  final String postid;
  final String commentid;
 CommentdeleteEvent({required this.postid,required this.commentid});
}
class PostSearchEvent extends PostEvent {
  final String value;
 PostSearchEvent({required this.value});
}

