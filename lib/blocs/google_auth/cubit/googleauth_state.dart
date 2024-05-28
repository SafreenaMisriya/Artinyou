part of 'googleauth_cubit.dart';

@immutable
sealed class GoogleauthState {}

final class GoogleauthInitial extends GoogleauthState {}
final class GoogleauthLoadingState extends GoogleauthState {}
final class GoogleauthsuccessState extends GoogleauthState {
  final User user;
  GoogleauthsuccessState(this.user);
}
final class GoogleauthFailedState extends GoogleauthState {
  final String error;
  GoogleauthFailedState(this.error);
}
final class Googleunauthenticated extends GoogleauthState{}