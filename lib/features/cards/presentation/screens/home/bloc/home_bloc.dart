import 'dart:async';

import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/usecases/get_all_cards_usecase.dart';
import 'package:card_hive/features/cards/domain/usecases/watch_all_cards_usecase.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_event.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<CardEntity> cards = [];
  final Logger _logger;

  final GetAllCardsUsecase _getAllCardsUsecase;
  final WatchAllCardsUsecase _watchAllCardsUsecase;
  StreamSubscription<DataState<List<CardEntity>>>? _watchSub;
  HomeBloc(this._logger, this._getAllCardsUsecase, this._watchAllCardsUsecase)
    : super(const HomeInitial()) {
    on<GetAllCardsEvent>(_getAllCards);
    on<UpdateCardsEvent>(_updateCards);
    on<StartWatchCardsEvent>(_startWatchCards);
    on<StopWatchCardsEvent>(_stopWatchCards);
    on<InternalWatchData>(_onInternalWatchData);
    on<InternalWatchFailed>(_onInternalWatchFailed);
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

  FutureOr<void> _startWatchCards(
    StartWatchCardsEvent event,
    Emitter<HomeState> emit,
  ) async {
    _logger.d('Starting to watch cards');
    await _watchSub?.cancel();

    final stream = await _watchAllCardsUsecase();

    // _watchSub = streamResult.listen((dataState) {
    //   if (dataState is DataFailed) {
    //     emit(HomeError(dataState.exception.toString()));
    //   } else {
    //     emit(HomeLoaded(dataState.data ?? []));
    //   }
    // });
    _watchSub = stream.listen((dataState) {
      if (dataState is DataFailed) {
        _logger.d('Stream add failed event');
        add(InternalWatchFailed(dataState.exception));
      } else {
        _logger.d('Stream add data event');
        add(InternalWatchData(dataState.data ?? []));
      }
    }, onError: (err) => add(InternalWatchFailed(err)));
    // await emit.forEach<DataState<List<CardEntity>>>(
    //   stream,
    //   onData: (dataState) {
    //     _logger.d('onData: stream handle: $dataState');
    //     if (dataState is DataFailed)
    //       return HomeError(dataState.exception.toString());
    //     // ignore: avoid_print
    //     dataState.data?.forEach(print);
    //     return HomeLoaded(dataState.data ?? []);
    //   },
    //   onError: (err, _) => HomeError(err.toString()),
    // );
    _logger.d('Exit strea ???');
  }

  FutureOr<void> _stopWatchCards(
    StopWatchCardsEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _watchSub?.cancel();
    _watchSub = null;
  }

  @override
  Future<void> close() {
    _watchSub?.cancel();
    return super.close();
  }

  FutureOr<void> _onInternalWatchData(
    InternalWatchData event,
    Emitter<HomeState> emit,
  ) {
    emit(const HomeLoading());
    emit(HomeLoaded(event.cards));
  }

  FutureOr<void> _onInternalWatchFailed(
    InternalWatchFailed event,
    Emitter<HomeState> emit,
  ) {
    emit(const HomeLoading());
    emit(HomeError(event.error?.toString() ?? 'Uknown error'));
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
