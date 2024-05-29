// ignore_for_file: must_be_immutable

import 'package:art_inyou/blocs/internet/internet_bloc.dart';
import 'package:art_inyou/screens/bottombar/bottombar.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetCheck extends StatelessWidget {
  InternetCheck({super.key});
  late InternetBloc internet;
  @override
  Widget build(BuildContext context) {
    internet = BlocProvider.of<InternetBloc>(context);
    double height = Responsive.screenHeight(context);
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<InternetBloc, InternetState>(
          builder: (context, state) {
            if (state is InternetDisconnectedState) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/image/internet.png',height: height*0.3,),
                  const Text('NO INTERNET',style: MyFonts.boldTextStyle,),
                ],
              ));
            } else if (state is InternetConnectedState) {
              return const BottomBar();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
