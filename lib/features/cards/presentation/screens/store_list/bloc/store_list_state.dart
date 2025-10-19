import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:equatable/equatable.dart';

sealed class StoreListState extends Equatable {
  const StoreListState();
  @override
  List<Object> get props => [];
}

class StoreListInitial extends StoreListState {
  const StoreListInitial() : super();

  @override
  List<Object> get props => [];
}

class StoreListLoading extends StoreListState {
  const StoreListLoading() : super();
}

class StoreListLoaded extends StoreListState {
  final List<StoreEntity> stores;
  const StoreListLoaded(this.stores) : super();
}

class StoreListError extends StoreListState {
  final String message;
  const StoreListError(this.message) : super();
}
