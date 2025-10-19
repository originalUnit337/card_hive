import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:card_hive/features/cards/domain/repository/store_repositry.dart';

class ImportStoreUsecase
    implements UseCase<DataState<List<StoreEntity>>, void> {
  final StoreRepositry _storeRepositry;
  ImportStoreUsecase(this._storeRepositry);

  @override
  Future<DataState<List<StoreEntity>>> call({void params}) {
    return _storeRepositry.loadStoresFromAssets();
  }
}
