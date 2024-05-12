part of 'post_bloc.dart';

@immutable
sealed class PostState {}
enum ImageEvent { selectImage, uploadImage }
final class PostInitial extends PostState {}
final class Postloading extends PostState{}
final class PostSuccessState extends PostState{}
final class PostErrorstate extends PostState{
  final String error;
  PostErrorstate({required this.error});
}
class ImageSelected extends PostState {
  final List<XFile> images;

  ImageSelected(this.images);
}

class ImageUploading extends PostState {}

class ImageUploaded extends PostState {
  final List<String> imageUrls;

  ImageUploaded(this.imageUrls);
}
class ImageErrorState extends PostState{
  final String error;
  ImageErrorState({required this.error});
}
class PostEditsuccessState extends PostState{
  
}
class PostEditerrorstate extends PostState{
  final String error;
  PostEditerrorstate({required this .error});
}
class Postdeletesuccessstate extends PostState{}

class Postdeleteerrorstate extends PostState{
  final String error;
  Postdeleteerrorstate({required this.error});
  }
  class PostedCommentstate extends PostState{}

class PostCommenterrorstate extends PostState{
  final String error;
  PostCommenterrorstate({required this.error});
  }