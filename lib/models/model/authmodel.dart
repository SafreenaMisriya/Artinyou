import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthModel{
  FirebaseAuth authentication =FirebaseAuth.instance;
  User? firebaseuser;
  FirebaseFirestore database= FirebaseFirestore.instance;
  Future<void>loginwithAuth(
  { 
    required String phoneNumber,
    required Function(PhoneAuthCredential)verificationcompleted,
    required Function(FirebaseAuthException)verificationfailed,
    required Function(String,int?)codesent,
    required Function(String)codeAuthRetrivaltimeout, 
  })
async{
  await authentication.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: verificationcompleted,
     verificationFailed: verificationfailed,
      codeSent: codesent,
       codeAutoRetrievalTimeout: codeAuthRetrivaltimeout);
}
 }