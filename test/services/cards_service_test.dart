import 'dart:io';

import 'package:card_hive/features/cards/data/datasources/cards_service.dart';
import 'package:card_hive/features/cards/data/models/card_model.dart';
import 'package:card_hive/objectbox.g.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper: create temporary store for tests.
/// Adjust modelSchemas if needed; here we use generated model from objectbox.g.dart
Future<Store> createTestStore() async {
  final dir = Directory.systemTemp.createTempSync('card_hive_test_');
  return Store(getObjectBoxModel(), directory: dir.path);
}

void main() {
  late Store store;
  late Box<CardModel> box;
  late CardsService service;

  setUp(() async {
    store = await createTestStore();
    box = store.box<CardModel>();
    service = CardsService(box);
  });

  tearDown(() {
    store.close();
    // remove temporary directory
    try {
      Directory(store.directoryPath).deleteSync(recursive: true);
    } catch (_) {}
  });

  group('CardsService basic CRUD', () {
    test('putCard & getById should store and retrieve card', () async {
      final model = CardModel(
        id: 0,
        name: 'Supermarket',
        number: '1234567890',
        colorValue: 0xFFFFFFFF,
      );

      final id = await service.putCard(model);
      expect(id, isNonZero);

      final fetched = await service.getById(id);
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Supermarket');
      expect(fetched.number, '1234567890');
      expect(fetched.colorValue, 0xFFFFFFFF);
    });

    test('getAll returns multiple inserted cards', () async {
      final m1 = CardModel(id: 0, name: 'A', number: '1', colorValue: 1);
      final m2 = CardModel(id: 0, name: 'B', number: '2', colorValue: 2);

      await service.putMany([m1, m2]);
      final all = await service.getAll();
      expect(all.length, 2);
      final names = all.map((e) => e.name).toSet();
      expect(names, containsAll(['A', 'B']));
    });

    test('remove deletes card and getById returns null', () async {
      final model = CardModel(id: 0, name: 'X', number: '9', colorValue: 9);
      final id = await service.putCard(model);
      final removed = await service.remove(id);
      expect(removed, isTrue);

      final fetched = await service.getById(id);
      expect(fetched, isNull);
    });
  });

  group('searchByNameOrNumber', () {
    setUp(() async {
      await service.putMany([
        CardModel(id: 0, name: 'Supermart', number: '123', colorValue: 1),
        CardModel(id: 0, name: 'MarketPlace', number: '456', colorValue: 2),
        CardModel(id: 0, name: 'Shop', number: '789', colorValue: 3),
      ]);
    });

    test('search finds by partial name case-insensitive', () async {
      final res = await service.searchByNameOrNumber('market');
      final names = res.map((e) => e.name).toList();
      expect(names.length, 2);
      expect(names, containsAll(['Supermart', 'MarketPlace']));
    });

    test('search finds by partial number', () async {
      final res = await service.searchByNameOrNumber('78');
      expect(res.length, 1);
      expect(res.first.name, 'Shop');
    });

    test('search with empty string returns all', () async {
      final res = await service.searchByNameOrNumber('');
      // depending on ObjectBox behavior empty contains -> all records
      expect(res.length, 3);
    });
  });

  group('putMany edge cases', () {
    test('putMany inserts many records and returns ids', () async {
      final models = List.generate(
        50,
        (i) => CardModel(id: 0, name: 'N$i', number: 'num$i', colorValue: i),
      );
      final ids = await service.putMany(models);
      expect(ids.length, 50);
      final all = await service.getAll();
      expect(all.length, 50);
    });
  });

  group('streams: watchAll and watchById', () {
    test('watchAll emits initial and subsequent updates', () async {
      // insert initial
      await service.putCard(CardModel(id: 0, name: 'one', number: '1', colorValue: 1));
      final stream = service.watchAll();
      final sub = stream.asBroadcastStream();

      // first emission (initial)
      final first = await sub.first;
      expect(first.map((e) => e.name), contains('one'));

      // add another card and expect next emission
      final futureNext = sub.skip(1).first;
      await service.putCard(CardModel(id: 0, name: 'two', number: '2', colorValue: 2));
      final next = await futureNext;
      expect(next.map((e) => e.name), containsAll(['one', 'two']));

      await sub.drain();
    }, timeout: Timeout(Duration(seconds: 10)));

    test('watchById emits initial and updates for single id', () async {
      final id = await service.putCard(CardModel(id: 0, name: 'single', number: '9', colorValue: 9));
      final stream = service.watchById(id);
      final sub = stream.asBroadcastStream();

      final first = await sub.first;
      expect(first, isNotNull);
      expect(first!.name, 'single');

      final futureNext = sub.skip(1).first;
      final fetched = await service.getById(id);
      // update name
      final updated = CardModel(
        id: id,
        name: 'single-updated',
        number: fetched!.number,
        colorValue: fetched.colorValue,
      );
      await service.putCard(updated);

      final next = await futureNext;
      expect(next, isNotNull);
      expect(next!.name, 'single-updated');

      await sub.drain();
    }, timeout: Timeout(Duration(seconds: 10)));
  });

  group('negative scenarios', () {
    test('putCard with empty name or number should be handled (no crash)', () async {
      final bad1 = CardModel(id: 0, name: '', number: '123', colorValue: 1);
      final bad2 = CardModel(id: 0, name: 'Name', number: '', colorValue: 1);

      // service currently will save; test ensures DB does not crash and values stored as given
      final id1 = await service.putCard(bad1);
      final id2 = await service.putCard(bad2);

      final f1 = await service.getById(id1);
      final f2 = await service.getById(id2);

      expect(f1, isNotNull);
      expect(f1!.name, '');
      expect(f2, isNotNull);
      expect(f2!.number, '');
    });

    test('searchByNameOrNumber with special characters does not throw', () async {
      await service.putCard(CardModel(id: 0, name: 'Normal', number: '111', colorValue: 1));
      final res = await service.searchByNameOrNumber('%_)(*');
      expect(res, isA<List<CardModel>>());
    });
  });
}
