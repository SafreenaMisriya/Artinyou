part of 'save_bloc.dart';

@immutable
sealed class SaveState {}

final class SaveInitial extends SaveState {}
final class Saveloading extends SaveState{}
final class Savesuccess extends SaveState{}
final class SaveError extends SaveState{
  final String error;
  SaveError({required this.error});
}
final class Savedeletesuccess extends SaveState{}
final class SavedeleteError extends SaveState{
  final String error;
  SavedeleteError({required this.error});
}