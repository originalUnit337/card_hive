import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';

abstract class StoreRepositry {
  Future<DataState<List<StoreEntity>>> loadStoresFromAssets();
  Future<DataState<List<StoreEntity>>> searchStores(String query);
}
