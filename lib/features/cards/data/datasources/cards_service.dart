import 'dart:async';

import 'package:card_hive/features/cards/data/models/card_model.dart';
import 'package:card_hive/objectbox.g.dart';

class CardsService {
  final Box<CardModel> box;

  CardsService(this.box);

  Future<int> putCard(CardModel model) async => box.putAsync(model);

  Future<List<CardModel>> getAll() async => box.getAllAsync();

  Future<CardModel?> getById(int id) async => box.getAsync(id);

  Future<bool> remove(int id) async => box.removeAsync(id);

  Future<List<CardModel>> searchByNameOrNumber(String query) async {
    final q =
        box
            .query(
              CardModel_.name
                  .contains(query, caseSensitive: false)
                  .or(CardModel_.number.contains(query, caseSensitive: false)),
            )
            .build();
    try {
      return await q.findAsync();
    } finally {
      q.close();
    }
  }

  Future<List<int>> putMany(List<CardModel> models) async =>
      box.putManyAsync(models);
}
