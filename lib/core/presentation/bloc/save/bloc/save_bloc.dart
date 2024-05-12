import 'package:art_inyou/core/data/repository/save_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'save_event.dart';
part 'save_state.dart';
SaveRepository save=SaveRepository();
class SaveBloc extends Bloc<SaveEvent, SaveState> {
  SaveBloc() : super(SaveInitial()) {
    on<SavePostEvent>((event, emit) async{
      emit(Saveloading());
     try {
       await save.savePost(event.postid, event.userid);
       emit(Savesuccess());
     } catch (e) {
       emit(SaveError(error: e.toString()));
     }
    });

     on<SavedeletePostEvent>((event, emit) async{
      emit(Saveloading());
     try {
       await save.deleteSavedPost(event.postid, event.userid);
       emit(Savedeletesuccess());
     } catch (e) {
       emit(SavedeleteError(error: e.toString()));
     }
    });
  }
}
