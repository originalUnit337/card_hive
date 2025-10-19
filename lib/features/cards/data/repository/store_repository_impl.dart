import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/data/datasources/assets_store_service.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:card_hive/features/cards/domain/repository/store_repositry.dart';

class StoreRepositoryImpl implements StoreRepositry {
  final AssetsStoreService _assetsStoreService;
  StoreRepositoryImpl(this._assetsStoreService);

  @override
  Future<DataState<List<StoreEntity>>> loadStoresFromAssets() async {
    try {
      final result = await _assetsStoreService.loadAll();
      return DataSuccess(result);
    } catch (e) {
      if (e is Exception) {
        return DataFailed(e);
      } else {
        return DataFailed(Exception(e));
      }
    }
  }

  @override
  Future<DataState<List<StoreEntity>>> searchStores(String query) async {
    try {
      final result = await _assetsStoreService.search(query);
      return DataSuccess(result);
    } catch (e) {
      if (e is Exception) {
        return DataFailed(e);
      } else {
        return DataFailed(Exception(e));
      }
    }
  }
}
