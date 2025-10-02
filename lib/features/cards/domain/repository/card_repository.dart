import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';

abstract class CardRepository {
  Future<DataState<List<CardEntity>>> getAll();
  Future<CardEntity?> getById(int id);
  Future<DataState<int>> putCard(CardEntity card);
  Future<DataState<bool>> remove(int id);
  Future<List<CardEntity>> searchByNameOrNumber(String query);
  Future<List<int>> putMany(List<CardEntity> models);
}
