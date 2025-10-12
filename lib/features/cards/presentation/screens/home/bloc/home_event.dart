import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetAllCardsEvent extends HomeEvent {
  const GetAllCardsEvent();
}

class StartWatchCardsEvent extends HomeEvent {}

class StopWatchCardsEvent extends HomeEvent {}

class InternalWatchData extends HomeEvent {
  final List<CardEntity> cards;
  const InternalWatchData(this.cards);
}

class InternalWatchFailed extends HomeEvent {
  final Object? error;
  const InternalWatchFailed(this.error);
}
