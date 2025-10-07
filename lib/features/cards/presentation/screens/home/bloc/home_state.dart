import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial() : super();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading() : super();
}

class HomeLoaded extends HomeState {
  final List<CardEntity> cards;
  const HomeLoaded(this.cards) : super();
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message) : super();
}
