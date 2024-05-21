// ignore_for_file: must_be_immutable

import 'package:art_inyou/core/presentation/bloc/internet/internet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetCheck extends StatelessWidget {
  InternetCheck({super.key});
  late InternetBloc internet;
  @override
  Widget build(BuildContext context) {
    internet = BlocProvider.of<InternetBloc>(context);
    return Scaffold(
      body: BlocBuilder<InternetBloc, InternetState>(
        builder: (context, state) {
          if (state is InternetConnectedState) {
            return const Text('dd');
          } else if (state is InternetDisconnectedState) {
            return const Text('tt');
          } else {
            return const Center(
              child: Text('Checking for Interner'),
            );
          }
        },
      ),
    );
  }
}
