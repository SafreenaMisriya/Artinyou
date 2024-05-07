// ignore_for_file: must_be_immutable

part of 'message_bloc.dart';

@immutable
sealed class MessageEvent {}
class MessageAddEvent extends MessageEvent{
   final MessageModel messages;
 MessageAddEvent({required this.messages});
}