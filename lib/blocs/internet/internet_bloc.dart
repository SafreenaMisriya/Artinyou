import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
   late StreamSubscription internetSubscription;
  InternetBloc() : super(InternetInitial()) {
    internetSubscription = InternetConnection().onStatusChange.listen((event) {
      if (event == InternetStatus.connected) {
        add(InternetConnected());
      } else {
        add(InternetDisconnected());
      }
    });

    on<InternetConnected>((event, emit) => emit(InternetConnectedState()));
    on<InternetDisconnected>((event, emit) => emit(InternetDisconnectedState()));
  }

  @override
  Future<void> close() {
    internetSubscription.cancel();
    return super.close();
  }
  }
