import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:card_hive/features/cards/domain/repository/store_repositry.dart';

class SearchStoresUsecase
    implements UseCase<DataState<List<StoreEntity>>, String> {
  final StoreRepositry _storeRepository;

  SearchStoresUsecase(this._storeRepository);

  @override
  Future<DataState<List<StoreEntity>>> call({required String params}) {
    return _storeRepository.searchStores(params);
  }
}
