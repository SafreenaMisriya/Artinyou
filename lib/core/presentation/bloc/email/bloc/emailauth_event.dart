part of 'emailauth_bloc.dart';

@immutable
sealed class EmailauthEvent {}
class CheckLoginStatusEvent extends EmailauthEvent{}
class LoginEvent extends EmailauthEvent {
  final String email;
  final String password;
  LoginEvent({required this.email,required this.password});
}
class SignInEvent extends EmailauthEvent{
  final UserModel user;
 SignInEvent({required this.user});
}
class LogOutEvent extends EmailauthEvent{}
class ForgotpasswordEvent extends EmailauthEvent{
  final String email;
  ForgotpasswordEvent({required this.email});
}
