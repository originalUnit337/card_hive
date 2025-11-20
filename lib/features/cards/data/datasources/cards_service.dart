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

  Stream<List<CardModel>> watchAll() async* {
    // final inintialQuery = box.query().build();
    // try {
    //   yield await inintialQuery.findAsync();
    // } finally {
    //   inintialQuery.close();
    // }
    // final q = box.query().build();
    // await for (final _ in q.stream()) {
    //   final q2 = box.query().build();
    //   try {
    //     yield await q2.findAsync();
    //   } finally {
    //     q2.close();
    //   }
    // }
    // q.close();
    final query = box.query().build();
    try {
      // initial
      yield await query.findAsync();

      // subsequent updates
      await for (final _ in query.stream()) {
        yield await query.findAsync();
      }
    } finally {
      query.close();
    }
  }

  Stream<CardModel?> watchById(int id) async* {
    final initialQuery = box.query(CardModel_.id.equals(id)).build();
    try {
      yield await initialQuery.findFirstAsync();
    } finally {
      initialQuery.close();
    }

    final q = box.query(CardModel_.id.equals(id)).build();
    await for (final _ in q.stream()) {
      final q2 = box.query(CardModel_.id.equals(id)).build();
      try {
        yield await q2.findFirstAsync();
      } finally {
        q2.close();
      }
    }
    q.close();
  }
}
