import 'package:bloc/bloc.dart';

enum EmojiState { show, hide }

class EmojiCubit extends Cubit<EmojiState> {
  EmojiCubit() : super(EmojiState.hide);
  void toggleEmoji() {
    emit(state == EmojiState.show ? EmojiState.hide : EmojiState.show);
  }
}
