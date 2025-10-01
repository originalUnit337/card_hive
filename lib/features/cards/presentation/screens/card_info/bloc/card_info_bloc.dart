import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/domain/usecases/add_or_update_card_usecase.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_event.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_state.dart';

class CardInfoBloc extends Bloc<CardInfoEvent, CardInfoState> {
  final AddOrUpdateCardUsecase _addOrUpdateCardUsecase;
  CardInfoBloc(this._addOrUpdateCardUsecase) : super(const CardInfoInitial()) {
    on<SaveCardEvent>(_saveCard);
  }

  FutureOr<void> _saveCard(
    SaveCardEvent event,
    Emitter<CardInfoState> emit,
  ) async {
    final result = await _addOrUpdateCardUsecase(params: event.card);
    if (result is DataFailed) {
      emit(CardInfoError(result.exception.toString()));
    } else {
      emit(CardInfoLoaded(event.card));
    }
  }
}
