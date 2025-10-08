import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/repository/card_repository.dart';

class WatchAllCardsUsecase
    implements UseCase<Stream<DataState<List<CardEntity>>>, void> {
  final CardRepository _cardRepository;

  WatchAllCardsUsecase(this._cardRepository);

  @override
  Future<Stream<DataState<List<CardEntity>>>> call({void params}) async {
    final stream = _cardRepository.watchAll();

    return stream
        .map(DataSuccess.new)
        .handleError((error) => DataFailed(Exception(error)));
  }
}
