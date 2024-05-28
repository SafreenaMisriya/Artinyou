
import 'package:art_inyou/repositories/chat/chat_repository.dart';
import 'package:art_inyou/repositories/post/post_repository.dart';
import 'package:art_inyou/repositories/profile/profile_repository.dart';
import 'package:art_inyou/blocs/emoji/emoji_cubit.dart';
import 'package:art_inyou/blocs/message/message_bloc.dart';
import 'package:art_inyou/blocs/email/bloc/emailauth_bloc.dart';
import 'package:art_inyou/blocs/google_auth/cubit/googleauth_cubit.dart';
import 'package:art_inyou/blocs/orders/orders_cubit.dart';
import 'package:art_inyou/blocs/otpauth_bloc/bloc/otpauth_bloc_bloc.dart';
import 'package:art_inyou/blocs/post/bloc/post_bloc.dart';
import 'package:art_inyou/blocs/profile/bloc/profile_bloc.dart';
import 'package:art_inyou/blocs/save/bloc/save_bloc.dart';
import 'package:art_inyou/blocs/softcopy/softcopy_bloc.dart';
import 'package:art_inyou/blocs/toggle_cubit.dart';
import 'package:art_inyou/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'blocs/hardcopy/hardcopy_bloc.dart';
import 'services/firebase_options.dart';

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
         BlocProvider<OrdersCubit>(create: (context)=>OrdersCubit()),
        
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
