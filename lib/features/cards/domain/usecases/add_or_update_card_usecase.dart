import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/repository/card_repository.dart';

class AddOrUpdateCardUsecase implements UseCase<DataState<int>, CardEntity> {
  final CardRepository _cardRepository;

  AddOrUpdateCardUsecase(this._cardRepository);

  @override
  Future<DataState<int>> call({required CardEntity params}) async {
    return _cardRepository.putCard(params);
  }
}
