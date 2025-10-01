import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:equatable/equatable.dart';

enum CardInfoStatus { initial, loading, loaded, edited, saving, saved, failure }

sealed class CardInfoState extends Equatable {
  const CardInfoState();
  @override
  List<Object?> get props => [];
}

class CardInfoInitial extends CardInfoState {
  const CardInfoInitial() : super();

  @override
  List<Object?> get props => [];
}

class CardInfoLoading extends CardInfoState {
  const CardInfoLoading() : super();
}

class CardInfoLoaded extends CardInfoState {
  final CardEntity card;
  const CardInfoLoaded(this.card) : super();
}

class CardInfoError extends CardInfoState {
  final String message;
  const CardInfoError(this.message) : super();
}
