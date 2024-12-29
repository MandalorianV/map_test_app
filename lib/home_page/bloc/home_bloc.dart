import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>(
      (HomeEvent event, Emitter<HomeState> emit) {},
    );
    on<PathRecorderEvent>((PathRecorderEvent event, Emitter<HomeState> emit) {
      emit(PathRecorderState(activate: !event.activate));
    });
  }
}
