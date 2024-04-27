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
