import 'dart:async';

import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:card_hive/features/cards/domain/usecases/get_all_cards_usecase.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_event.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<CardEntity> cards = [];
  List<StoreEntity> store = [];
  final Logger _logger;

  final GetAllCardsUsecase _getAllCardsUsecase;
  HomeBloc(this._logger, this._getAllCardsUsecase)
    : super(const HomeInitial()) {
    on<GetAllCardsEvent>(_getAllCards);
    on<UpdateCardsEvent>(_updateCards);
  }

  FutureOr<void> _getAllCards(
    GetAllCardsEvent event,
    Emitter<HomeState> emit,
  ) async {
    _logger.d('[HomeBLOC] Getting all cards');
    emit(const HomeLoading());
    final result = await _getAllCardsUsecase();
    _logger.i('result: $result');
    if (result is DataFailed) {
      emit(HomeError(result.exception.toString()));
    } else {
      cards = result.data ?? [];
      emit(HomeLoaded(result.data ?? []));
    }
  }

  FutureOr<void> _updateCards(
    UpdateCardsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    cards = event.cards;
    emit(HomeLoaded(event.cards));
  }
}
