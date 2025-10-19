import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:equatable/equatable.dart';

sealed class StoreListEvent extends Equatable {
  const StoreListEvent();

  @override
  List<Object?> get props => [];
}

class ImportAllStoresEvent extends StoreListEvent {
  final List<StoreEntity> stores;

  const ImportAllStoresEvent(this.stores);
}

class SearchStoresEvent extends StoreListEvent {
  final String query;

  const SearchStoresEvent(this.query);
}

class ClearSearchEvent extends StoreListEvent {
  const ClearSearchEvent();
}
