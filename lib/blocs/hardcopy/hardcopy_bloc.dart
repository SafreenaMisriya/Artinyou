
import 'package:art_inyou/models/model/addressmodel.dart';
import 'package:art_inyou/repositories/address/address_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'hardcopy_event.dart';
part 'hardcopy_state.dart';
final AddressStorage storage=AddressStorage();
class HardcopyBloc extends Bloc<HardcopyEvent, HardcopyState> {
  HardcopyBloc() : super(HardcopyState.initial()) {
    on<NextStephardcopyEvent>((event, emit) {
      if (state.currentStep < state.totalSteps - 1) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      } else {
        emit(state.copyWith(completed: true));
      }
    });

    on<PreviousStephardcopyEvent>((event, emit) {
      if (state.currentStep > 0) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<GoToStephardcopyEvent>((event, emit) {
      emit(state.copyWith(currentStep: event.step));
    });
    on<AddressEvent>((event, emit)async {
     try {
        await storage.addAddress(event.addressModel, event.userid);
        emit(state.copyWith(completed: true));
      } catch (e) {
        throw Exception(e.toString());
      }
    });
     on<UpdateaddressEvent>((event, emit)async {
     try {
        if (event.id.isEmpty) {
          throw Exception("Document ID cannot be empty");
        }
        await storage.updateaddress(event.userid, event.addressModel, event.id);
        emit(state.copyWith(completed: true));
      } catch (e) {
        throw Exception(e.toString());
      }
    });
  }
}
