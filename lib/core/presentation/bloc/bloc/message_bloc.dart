import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:art_inyou/core/data/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository chatrepository;
  MessageBloc({required this.chatrepository}) : super(MessageInitial()) {
    on<MessageAddEvent>((event, emit) async{
      emit(Messageloading());
    try {
      await chatrepository.addMessages(event.messages);
      emit(MessageSuccess());

    } catch (e) {
      emit(MessaggeError(error: e.toString()));
    }
    });
  }
}
