import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'softcopy_event.dart';
part 'softcopy_state.dart';

class SoftcopyBloc extends Bloc<SoftcopyEvent, SoftcopyState> {
  SoftcopyBloc() : super(SoftcopyState.initial()) {
    on<NextStepEvent>((event, emit) {
      if (state.currentStep < state.totalSteps - 1) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      } else {
        emit(state.copyWith(completed: true));
      }
    });

    on<PreviousStepEvent>((event, emit) {
      if (state.currentStep > 0) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<GoToStepEvent>((event, emit) {
        emit(state.copyWith(currentStep: event.step));
      
    });
    on<PaymentSuccessEvent>((event, emit) {
      emit(state.copyWith( paymentCompleted: true));
    });

    on<PaymentFailureEvent>((event, emit) {
      emit(state.copyWith(paymentCompleted: false));
    });
    on<DownloadSuccessEvent>((event, emit){
    emit(state.copyWith(completed: true));
    });
  }
}
