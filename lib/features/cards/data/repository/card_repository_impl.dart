import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/data/datasources/cards_service.dart';
import 'package:card_hive/features/cards/data/mapper/card_mapper.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/repository/card_repository.dart';
import 'package:logger/logger.dart';

class CardRepositoryImpl implements CardRepository {
  final CardsService _cardsService;
  final Logger _logger;

  CardRepositoryImpl(this._cardsService, this._logger);
  @override
  Future<List<CardEntity>> getAll() async {
    try {
      _logger.d('Enter getAll');
      final result = await _cardsService.getAll();
      return result.map((e) => CardMapper.fromModel(e)).toList();
    } catch (e) {
      _logger.e('Error getAll $e');
      rethrow;
    }
  }

  @override
  Future<CardEntity?> getById(int id) async {
    try {
      _logger.d('Enter getById');
      final result = await _cardsService.getById(id);
      return result == null ? null : CardMapper.fromModel(result);
    } catch (e) {
      _logger.e('Error getById $e');
      rethrow;
    }
  }

  @override
  Future<DataState<int>> putCard(CardEntity card) async {
    try {
      _logger.d('Enter putCard');
      final result = await _cardsService.putCard(CardMapper.toModel(card));
      if (result >= 0) {
        return DataSuccess(result);
      } else {
        return DataFailed(Exception('error: $result was not >= 0'));
      }
    } catch (e) {
      _logger.e('Error putCard $e');
      if (e is Exception) {
        return DataFailed(e);
      } else {
        return DataFailed(Exception('error: $e'));
      }
    }
  }

  @override
  Future<List<int>> putMany(List<CardEntity> models) async {
    try {
      _logger.d('Enter putMany');
      return await _cardsService.putMany(
        models.map((e) => CardMapper.toModel(e)).toList(),
      );
    } catch (e) {
      _logger.e('Error putMany $e');
      rethrow;
    }
  }

  @override
  Future<bool> remove(int id) async {
    try {
      final result = await _cardsService.remove(id);
      return result;
    } catch (e) {
      _logger.e('Error remove $e');
      rethrow;
    }
  }

  @override
  Future<List<CardEntity>> searchByNameOrNumber(String query) async {
    try {
      _logger.d('Enter searchByNameOrNumber');
      final result = await _cardsService.searchByNameOrNumber(query);
      return result.map((e) => CardMapper.fromModel(e)).toList();
    } catch (e) {
      _logger.e('Error searchByNameOrNumber $e');
      rethrow;
    }
  }
}
