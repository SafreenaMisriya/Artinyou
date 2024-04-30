part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class Profileloading extends ProfileState {}

final class Profileaddstate extends ProfileState {}


final class Profileerrorstate extends ProfileState {
  final String error;
  Profileerrorstate({required this.error});
}

final class ProfileEditState extends ProfileState {}

final class ProfileEditError extends ProfileState {
  final String error;
  ProfileEditError({required this.error});
}
class ProfileLoaded extends ProfileState {
}

class ImageSelected extends ProfileState {
  final List<XFile> images;

  ImageSelected(this.images);
}

class ImageUploaded extends ProfileState {
  final List<String> imageUrls;

  ImageUploaded(this.imageUrls);
}
