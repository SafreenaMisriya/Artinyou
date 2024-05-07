part of 'message_bloc.dart';

@immutable
sealed class MessageState {}

final class MessageInitial extends MessageState {}
final class Messageloading extends MessageState{}
final class MessageSuccess extends MessageState{}
final class MessaggeError extends MessageState{
  final String error;
  MessaggeError({required this.error});
}
