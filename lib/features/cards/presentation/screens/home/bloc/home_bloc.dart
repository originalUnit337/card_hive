import 'dart:async';

import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/domain/usecases/get_all_cards_usecase.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_event.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllCardsUsecase _getAllCardsUsecase;
  HomeBloc(this._getAllCardsUsecase) : super(const HomeInitial()) {
    on<GetAllCardsEvent>(_getAllCards);
  }

  FutureOr<void> _getAllCards(
    GetAllCardsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _getAllCardsUsecase();
    if (result is DataFailed) {
      emit(HomeError(result.exception.toString()));
    } else {
      emit(HomeLoaded(result.data ?? []));
    }
  }
}
