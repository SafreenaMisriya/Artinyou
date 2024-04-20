part of 'otpauth_bloc_bloc.dart';

@immutable
sealed class OtpauthBlocState {}

final class OtpauthBlocInitial extends OtpauthBlocState {}
final class OtpAuthloadingState extends OtpauthBlocState {}
final class OtpAuthloadedState extends OtpauthBlocState {}
final class OtpAuthErrorState extends OtpauthBlocState {
  final String error;
  OtpAuthErrorState({required this.error});
}
final class OtpsentsuccessState extends OtpauthBlocState {
  final String verificationId;
  OtpsentsuccessState({required this.verificationId});
}
final class Signupscreenpsuccessstate extends OtpauthBlocState {}




