import 'package:card_hive/features/cards/domain/entities/card_entity.dart';

abstract class CardRepository {
  Future<List<CardEntity>> getAll();
  Future<CardEntity?> getById(int id);
  Future<int> putCard(CardEntity card);
  Future<bool> remove(int id);
  Future<List<CardEntity>> searchByNameOrNumber(String query);
  Future<List<int>> putMany(List<CardEntity> models);
}
