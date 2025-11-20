import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/repository/card_repository.dart';

class GetAllCardsUsecase extends UseCase<DataState<List<CardEntity>>, void> {
  final CardRepository _cardRepository;

  GetAllCardsUsecase(this._cardRepository);

  @override
  Future<DataState<List<CardEntity>>> call({void params}) {
    return _cardRepository.getAll();
  }
}
