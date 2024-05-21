part of 'internet_bloc.dart';

@immutable
sealed class InternetEvent {}
class InternetConnected extends InternetEvent {}

class InternetDisconnected extends InternetEvent {}