import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:card_hive/features/cards/domain/usecases/import_store_usecase.dart';
import 'package:card_hive/features/cards/domain/usecases/search_stores_usecase.dart';
import 'package:card_hive/features/cards/presentation/screens/store_list/bloc/store_list_event.dart';
import 'package:card_hive/features/cards/presentation/screens/store_list/bloc/store_list_state.dart';

class StoreListBloc extends Bloc<StoreListEvent, StoreListState> {
  List<StoreEntity> stores = [];

  final ImportStoreUsecase _importStoreUsecase;
  final SearchStoresUsecase _searchStoresUsecase;
  StoreListBloc(this._importStoreUsecase, this._searchStoresUsecase)
    : super(const StoreListInitial()) {
    on<ImportAllStoresEvent>(_importStores);
    on<SearchStoresEvent>(_searchStores);
    on<ClearSearchEvent>(_clearSearch);
  }

  FutureOr<void> _importStores(
    ImportAllStoresEvent event,
    Emitter<StoreListState> emit,
  ) async {
    emit(const StoreListLoading());
    final result = await _importStoreUsecase();
    if (result is DataFailed) {
      emit(StoreListError(result.exception.toString()));
    } else {
      stores = result.data ?? [];
      emit(StoreListLoaded(result.data ?? []));
    }
  }

  FutureOr<void> _searchStores(
    SearchStoresEvent event,
    Emitter<StoreListState> emit,
  ) async {
    emit(const StoreListLoading());
    final result = await _searchStoresUsecase(params: event.query);
    if (result is DataFailed) {
      emit(StoreListError(result.exception.toString()));
    } else {
      stores = result.data ?? [];
      emit(StoreListLoaded(result.data ?? []));
    }
  }

  FutureOr<void> _clearSearch(
    ClearSearchEvent event,
    Emitter<StoreListState> emit,
  ) {
    emit(const StoreListInitial());
  }
}
