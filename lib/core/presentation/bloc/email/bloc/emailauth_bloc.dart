// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:art_inyou/core/data/model/emailmodel.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'emailauth_event.dart';
part 'emailauth_state.dart';

class EmailauthBloc extends Bloc<EmailauthEvent, EmailauthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  EmailauthBloc() : super(EmailauthInitialState()) {
    // on<CheckLoginStatusEvent>(
    //   (event, emit) async {
    //     try {
    //       User? user = auth.currentUser;
    //       if (user != null) {
    //         emit(AuthenticatedState(user));
    //       } else {
    //         emit(Unauthenticated());
    //       }
    //     } catch (e) {
    //       emit(AuthenticatedErrorState(error: e.toString()));
    //     }
    //   },
    // );

    on<SignInEvent>(
      (event, emit) async {
        emit(EmailloadingState());
        try {
          UserCredential userCredential = await auth.createUserWithEmailAndPassword(
            email: event.user.email.toString(),
            password: event.user.password.toString(),
          );

          User? user = userCredential.user;
          if (user != null) {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'email': user.email,
              'name': event.user.username,
              'createdAt': DateTime.now(),
            });
            emit(AuthenticatedState(user));
          } else {
            emit(Unauthenticated());
          }
        } catch (e) {
          emit(AuthenticatedErrorState(error: e.toString()));
        }
      },
    );

    on<LogOutEvent>(
      (event, emit) async {
        try {
          await auth.signOut();
          emit(Unauthenticated());
        } catch (e) {
          emit(AuthenticatedErrorState(error: e.toString()));
        }
      },
    );
    on<LoginEvent>((event, emit) async{
      emit(EmailloadingState());
      try {
        final usercredential= await auth.signInWithEmailAndPassword(email: event.email, password: event.password);
        final user= usercredential.user;
        if(user!=null){
          emit(AuthenticatedState(user));
        }else{
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthenticatedErrorState(error: e.toString()));
      }
    },);
    on<ForgotpasswordEvent>((event, emit)async {
      emit(EmailloadingState());
      try {
      await auth.sendPasswordResetEmail(email: event.email);
     
      
      } catch (e) {
        emit(AuthenticatedErrorState(error: e.toString()));
      }
    },);
  }

}

