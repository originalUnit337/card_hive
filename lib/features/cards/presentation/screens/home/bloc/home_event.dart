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

class UpdateCardsEvent extends HomeEvent {
  final List<CardEntity> cards;
  const UpdateCardsEvent(this.cards);
}
