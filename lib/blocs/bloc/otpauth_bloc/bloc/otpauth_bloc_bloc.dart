

import 'package:art_inyou/models/model/authmodel.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'otpauth_bloc_event.dart';
part 'otpauth_bloc_state.dart';

class OtpauthBloc extends Bloc<OtpauthBlocEvent, OtpauthBlocState> {
  String loginResult=" " ;
  AuthModel authModel =AuthModel();
  UserCredential? userCredential;
    OtpauthBloc(super .initialState){
    on<SendOtpToPhoneEvent>((event,emit)async{
    emit(OtpAuthloadingState());
    try {
      await authModel.loginwithAuth(
        phoneNumber:event.number ,
       verificationcompleted: (AuthCredential credential){
        add(PhoneAuthverfied(credential: credential));
        },
       verificationfailed: (FirebaseAuthException e){
        add(OtperrorEvent(error: e));
       }, 
       codesent: (String verficationId,int? refreshToken){
        add(Onphonesentotp(verificationId: verficationId, token: refreshToken));
       },
        codeAuthRetrivaltimeout: (String verficationId){});
    } catch (e) {
      emit(OtpAuthErrorState(error: e.toString()));
    }
    });
    on<Onphonesentotp>((event, emit) {
      emit(OtpsentsuccessState(verificationId: event.verificationId));
    },);
 on<VerifySendOtp>((event, emit) {
  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: event.verificationId,
      smsCode: event.otpcode,
    );
    add(PhoneAuthverfied(credential: credential));
  } catch (e) {
    emit(OtpAuthErrorState(error: e.toString()));
  }
});

    on<OtperrorEvent>((event, emit) {
      emit(OtpAuthErrorState(error: event.error));
    },);
    on<PhoneAuthverfied>((event, emit)async {
      try {
        await authModel.authentication.signInWithCredential(event.credential).then((value){
          emit(Signupscreenpsuccessstate());
          emit(OtpAuthloadedState());
        });
      } catch (e) {
        emit(OtpAuthErrorState(error: e.toString()));
      }
    },);
     on<SignOutEvent>((event, emit) async {
      try {
        await FirebaseAuth.instance.signOut();
        emit(SignOutSuccessState());
      } catch (e) {
        emit(OtpAuthErrorState(error: e.toString()));
      }
    });
  }
}
