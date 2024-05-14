import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'googleauth_state.dart';

class GoogleauthCubit extends Cubit<GoogleauthState> {
  GoogleauthCubit() : super(GoogleauthInitial());
  final GoogleSignIn googleSignIn=GoogleSignIn();
  final auth =FirebaseAuth.instance;
  void signin()async{
    emit(GoogleauthLoadingState());
    try {
      final userAccount= await googleSignIn.signIn();
      if(userAccount==null)return;
      final GoogleSignInAuthentication googleauth= await userAccount.authentication;
      final credential =GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken,
      );
      final usercredential=await auth.signInWithCredential(credential);
      emit(GoogleauthsuccessState(usercredential.user!));
    } catch (e) {
      emit(GoogleauthFailedState(e.toString()));
    }
  }
  void logout()async{
  try {
     await googleSignIn.signOut(); 
      await auth.signOut(); 
      emit(Googleunauthenticated());
  } catch (e) {
    emit(GoogleauthFailedState(e.toString()));
  }

  }
  void login()async{
    emit(GoogleauthLoadingState());
    try {
      final GoogleSignInAccount? googleSignInAccount= await googleSignIn.signIn();
      if(googleSignInAccount !=null){
        final GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
        final AuthCredential credential= GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken
        );
        final usercredential=await auth.signInWithCredential(credential);
        emit(GoogleauthsuccessState( usercredential.user!));
      }
      
    } catch (e) {
       emit(GoogleauthFailedState(e.toString()));
    }
  }
  
}
