import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/cards/domain/repository/card_repository.dart';

class RemoveCardUsecase implements UseCase<DataState<bool>, int> {
  final CardRepository _cardRepository;

  RemoveCardUsecase(this._cardRepository);

  @override
  Future<DataState<bool>> call({required int params}) {
    return _cardRepository.remove(params);
  }
}
