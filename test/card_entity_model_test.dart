import 'dart:ui';

import 'package:card_hive/features/cards/data/mapper/card_mapper.dart';
import 'package:card_hive/features/cards/data/models/card_model.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CardEntity <-> CardModel mapper and entity tests', () {
    test('entity construction and props', () {
      final e = CardEntity(
        id: 1,
        name: 'My Card',
        number: '1234 5678 9012 3456',
        color: const Color(0xFF112233),
      );

      expect(e.id, 1);
      expect(e.name, 'My Card');
      expect(e.number, '1234 5678 9012 3456');
      expect(e.color.toARGB32(), 0xFF112233);
      expect(e.props.contains(1), isTrue);
      expect(e.props.contains('My Card'), isTrue);
    });

    test('toJson/fromJson preserves color and optional fields', () {
      final e = CardEntity(
        id: 2,
        name: 'Card 2',
        number: '9999',
        color: const Color(0xFF00FF00),
        label: 'label',
        logoPath: 'logo.png',
        rawBarcodeSvg: '<svg/>',
        backPath: 'back.png',
        frontPath: 'front.png',
        note: 'note',
      );

      final json = e.toJson();
      expect(json['id'], 2);
      expect(json['name'], 'Card 2');
      expect(json['number'], '9999');
      expect(json['color'], 0xFF00FF00);
      expect(json['label'], 'label');
      expect(json['logoPath'], 'logo.png');

      final from = CardEntity.fromJson(json);
      expect(from.id, e.id);
      expect(from.name, e.name);
      expect(from.number, e.number);
      expect(from.color.toARGB32(), e.color.toARGB32());
      expect(from.label, e.label);
      expect(from.logoPath, e.logoPath);
      expect(from.rawBarcodeSvg, e.rawBarcodeSvg);
      expect(from.backPath, e.backPath);
      expect(from.frontPath, e.frontPath);
      expect(from.note, e.note);
    });

    test('copyWith updates fields and respects logoPathSet', () {
      final original = CardEntity(
        id: 3,
        name: 'Orig',
        number: '0000',
        color: const Color(0xFFFFFFFF),
        logoPath: 'a.png',
      );

      final changed = original.copyWith(
        name: 'New',
        logoPathSet: true,
        logoPath: 'b.png',
      );

      expect(changed.id, 3);
      expect(changed.name, 'New');
      expect(changed.logoPath, 'b.png');

      final notChangedLogo = original.copyWith(name: 'Still', logoPath: 'x.png');
      expect(notChangedLogo.logoPath, 'a.png');
    });

    test('CardEntity -> CardModel using CardMapper.toModel', () {
      final e = CardEntity(
        id: 7,
        name: 'Map',
        number: '1111',
        color: const Color(0xFF123456),
        label: 'lbl',
        logoPath: 'lp',
        rawBarcodeSvg: 'svg',
        frontPath: 'f',
        backPath: 'b',
        note: 'n',
      );

      final m = CardMapper.toModel(e);

      expect(m.id, e.id);
      expect(m.name, e.name);
      expect(m.number, e.number);
      expect(m.colorValue, e.color.toARGB32()); // учитывает toARGB32() реализацию ниже
      expect(m.label, e.label);
      expect(m.logoPath, e.logoPath);
      expect(m.rawBarcodeSvg, e.rawBarcodeSvg);
      expect(m.frontPath, e.frontPath);
      expect(m.backPath, e.backPath);
      expect(m.note, e.note);
    });

    test('CardModel -> CardEntity using CardMapper.fromModel', () {
      final m = CardModel(
        id: 9,
        name: 'Model',
        number: '2222',
        colorValue: 0xFFCAFEBABE,
        label: 'l',
        logoPath: 'lp',
        rawBarcodeSvg: 'r',
        frontPath: 'f',
        backPath: 'b',
        note: 'n',
      );

      final e = CardMapper.fromModel(m);

      expect(e.id, m.id);
      expect(e.name, m.name);
      expect(e.number, m.number);
      expect(e.color, Color(m.colorValue));
      expect(e.logoPath, m.logoPath);
      expect(e.rawBarcodeSvg, m.rawBarcodeSvg);
      expect(e.frontPath, m.frontPath);
      expect(e.backPath, m.backPath);
      expect(e.note, m.note);
    });

    test('invalid JSON for CardEntity throws', () {
      expect(
        () => CardEntity.fromJson(const <String, dynamic>{}),
        throwsA(anyOf(isA<TypeError>(), isA<ArgumentError>())),
      );
    });
  });
}
