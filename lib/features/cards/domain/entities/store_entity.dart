import 'package:flutter/material.dart';

class StoreEntity {
  final String id;
  final String name;
  final String region;
  final String? logoReference;
  final double? logoAspectRatio;
  final Color colorValue;

  StoreEntity({
    required this.id,
    required this.name,
    required this.region,
    required this.colorValue,
    this.logoReference,
    this.logoAspectRatio,
  });

  StoreEntity copyWith({
    String? id,
    String? name,
    String? region,
    String? logoReference,
    double? logoAspectRatio,
    Color? colorValue,
  }) {
    return StoreEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      logoReference: logoReference ?? this.logoReference,
      logoAspectRatio: logoAspectRatio ?? this.logoAspectRatio,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  factory StoreEntity.fromJson(Map<String, dynamic> j) {
    final c = (j['color'] ?? {}) as Map<String, dynamic>;
    final a = (c['A'] as int? ?? 255) & 0xFF;
    final r = (c['R'] as int? ?? 0) & 0xFF;
    final g = (c['G'] as int? ?? 0) & 0xFF;
    final b = (c['B'] as int? ?? 0) & 0xFF;
    return StoreEntity(
      id: j['id'] as String,
      name: j['name'] as String,
      region: j['region'] as String,
      logoReference: j['logoReference'] as String?,
      logoAspectRatio: (j['logoAspectRatio'] as num?)?.toDouble(),
      colorValue: Color.fromARGB(a, r, g, b),
    );
  }
}
