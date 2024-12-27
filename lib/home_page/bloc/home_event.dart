part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class PathRecorderEvent extends HomeEvent {
  final bool activate;

  PathRecorderEvent({required this.activate});
}
