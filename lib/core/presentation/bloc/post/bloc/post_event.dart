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