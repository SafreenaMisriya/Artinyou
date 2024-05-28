part of 'emailauth_bloc.dart';

@immutable
sealed class EmailauthState {}
final class EmailauthInitialState extends EmailauthState{}
final class EmailloadingState extends EmailauthState{}
final class AuthenticatedState extends EmailauthState{
  final User? user;
  AuthenticatedState(this.user);
}
final class Unauthenticated extends EmailauthState{}
final class AuthenticatedErrorState extends EmailauthState{
  final String error;
  AuthenticatedErrorState({required this.error});
}
final class AuthenticatedloginErrorState extends EmailauthState{
  final String error;
  AuthenticatedloginErrorState({required this.error});
}
