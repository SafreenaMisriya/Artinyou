// ignore_for_file: prefer_typing_uninitialized_variables

part of 'otpauth_bloc_bloc.dart';

@immutable
sealed class OtpauthBlocEvent {}

class SendOtpToPhoneEvent extends OtpauthBlocEvent {
  final String number;
  SendOtpToPhoneEvent({required this.number});
}

class Onphonesentotp extends OtpauthBlocEvent {
  final String verificationId;
  final int? token;
  Onphonesentotp({required this.verificationId, required this.token});
}

class VerifySendOtp extends OtpauthBlocEvent {
  final String otpcode;
  final String verificationId;
  VerifySendOtp({required this.verificationId, required this.otpcode});
}

class OtperrorEvent extends OtpauthBlocEvent {
  final error;
  OtperrorEvent({required this.error});
}

class PhoneAuthverfied extends OtpauthBlocEvent {
  final AuthCredential credential;
  PhoneAuthverfied({required this.credential});
}
