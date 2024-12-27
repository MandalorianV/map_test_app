part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class PathRecorderState extends HomeState {
  final bool activate;

  const PathRecorderState({required this.activate});
  @override
  List<Object> get props => [activate];
}
