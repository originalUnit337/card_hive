import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/usecases/add_or_update_card_usecase.dart';
import 'package:card_hive/features/cards/domain/usecases/remove_card_usecase.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_event.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_state.dart';

class CardInfoBloc extends Bloc<CardInfoEvent, CardInfoState> {
  CardEntity? card;
  final AddOrUpdateCardUsecase _addOrUpdateCardUsecase;
  final RemoveCardUsecase _removeCardUsecase;
  CardInfoBloc(this._addOrUpdateCardUsecase, this._removeCardUsecase)
    : super(const CardInfoInitial()) {
    on<SaveCardEvent>(_saveCard);
    on<RemoveCardEvent>(_removeCard);
  }

  FutureOr<void> _saveCard(
    SaveCardEvent event,
    Emitter<CardInfoState> emit,
  ) async {
    emit(const CardInfoLoading());
    final result = await _addOrUpdateCardUsecase(params: event.card);
    if (result is DataFailed) {
      emit(CardInfoError(result.exception.toString()));
    } else {
      if (event.card.id == 0 && result.data != null) {
        final c = event.card.copyWith(id: result.data);
        card = c;
        emit(CardInfoLoaded(c));
      } else {
        card = event.card;
        emit(CardInfoLoaded(event.card));
      }
    }
  }

  FutureOr<void> _removeCard(
    RemoveCardEvent event,
    Emitter<CardInfoState> emit,
  ) async {
    final result = await _removeCardUsecase(params: event.id);
    if (result is DataFailed) {
      emit(CardInfoError(result.exception.toString()));
    } else {
      //TODO: Return some feedback of successful remove
    }
  }
}
