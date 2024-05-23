
import 'package:art_inyou/core/data/repository/chat_repository.dart';
import 'package:art_inyou/core/data/repository/post_repository.dart';
import 'package:art_inyou/core/data/repository/profile_repository.dart';
import 'package:art_inyou/core/presentation/bloc/emoji/emoji_cubit.dart';
import 'package:art_inyou/core/presentation/bloc/message/message_bloc.dart';
import 'package:art_inyou/core/presentation/bloc/email/bloc/emailauth_bloc.dart';
import 'package:art_inyou/core/presentation/bloc/google_auth/cubit/googleauth_cubit.dart';
import 'package:art_inyou/core/presentation/bloc/otpauth_bloc/bloc/otpauth_bloc_bloc.dart';
import 'package:art_inyou/core/presentation/bloc/post/bloc/post_bloc.dart';
import 'package:art_inyou/core/presentation/bloc/profile/bloc/profile_bloc.dart';
import 'package:art_inyou/core/presentation/bloc/save/bloc/save_bloc.dart';
import 'package:art_inyou/core/presentation/bloc/softcopy/softcopy_bloc.dart';
import 'package:art_inyou/core/presentation/bloc/toggle/toggle_cubit.dart';
import 'package:art_inyou/core/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/presentation/bloc/bloc/hardcopy_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OtpauthBloc>(
            create: (context) => OtpauthBloc(OtpauthBlocInitial())),
        BlocProvider<GoogleauthCubit>(create: (context) => GoogleauthCubit()),
        BlocProvider<EmailauthBloc>(create: (context) => EmailauthBloc(),),
        BlocProvider<PostBloc>(create: (context)=>PostBloc(firestoreService: FirestoreService())),
        BlocProvider<ProfileBloc>(create: (context)=>ProfileBloc(firestoreService: Profilestorage())),
        BlocProvider<MessageBloc>(create: (context)=>MessageBloc(chatrepository: ChatRepository())),
        BlocProvider<EmojiCubit>(create: (context)=>EmojiCubit()),
        BlocProvider<SaveBloc>(create: (context) => SaveBloc(),),
        BlocProvider<SoftcopyBloc>(create: (context)=>SoftcopyBloc()),
        BlocProvider<HardcopyBloc>(create: (context)=>HardcopyBloc()),
         BlocProvider<ToggleCubit>(create: (context)=>ToggleCubit()),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(),
          textTheme: GoogleFonts.latoTextTheme(),
        ),
        home:const SplashScreen(),
      ),
    );
  }
}
