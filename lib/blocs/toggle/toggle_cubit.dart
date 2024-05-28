import 'package:bloc/bloc.dart';

class ToggleCubit extends Cubit<bool> {
  ToggleCubit() : super(false);
   void toggle(bool value) => emit(value);
}
