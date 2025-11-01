import 'dart:convert';

import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:flutter/services.dart' show rootBundle;

class AssetsStoreService {
  final String assetPath;
  List<StoreEntity>? _cache;

  AssetsStoreService({this.assetPath = 'assets/stores.json'});

  Future<List<StoreEntity>> loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(assetPath);
    final arr = jsonDecode(raw) as List<dynamic>;
    _cache =
        arr
            .map((e) => StoreEntity.fromJson(e as Map<String, dynamic>))
            .toList();
    return _cache!;
  }

  Future<List<StoreEntity>> search(String query) async {
    final all = await loadAll();
    if (query.trim().isEmpty) return all;
    final q = query.toLowerCase();
    return all
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              s.region.toLowerCase().contains(q) ||
              s.id.toLowerCase().contains(q),
        )
        .toList();
  }
}
