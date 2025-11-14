import 'dart:io';
import 'dart:ui';

import 'package:card_hive/features/cards/domain/validators/card_entity_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CardEntityValidator', () {
    test('valid minimal entity passes', () {
      final errs = CardEntityValidator.validate(
        id: 0,
        name: 'Name',
        number: '1234',
        color: const Color(0xFF112233),
      );
      expect(errs, isEmpty);
    });

    test('missing required fields produce errors', () {
      final errs = CardEntityValidator.validate(
        id: -1,
        name: '   ',
        number: '',
        color: const Color(0xFF000000),
      );
      expect(errs.containsKey('id'), isTrue);
      expect(errs.containsKey('name'), isTrue);
      expect(errs.containsKey('number'), isTrue);
    });

    test('requireIdForUpdate enforces id>0', () {
      final errs = CardEntityValidator.validate(
        id: 0,
        name: 'N',
        number: '1234',
        color: const Color(0xFF000000),
        requireIdForUpdate: true,
      );
      expect(errs['id'], isNotNull);
    });

    test('note length restriction', () {
      final long = 'a' * 1001;
      final errs = CardEntityValidator.validate(
        id: 1,
        name: 'N',
        number: '1234',
        color: const Color(0xFF000000),
        note: long,
      );
      expect(errs.containsKey('note'), isTrue);
    });

    test('invalid logoPath: non-existent file', () {
      final errs = CardEntityValidator.validate(
        id: 1,
        name: 'N',
        number: '1234',
        color: const Color(0xFF000000),
        logoPath: '/no/such/file.png',
      );
      expect(errs['logoPath'], isNotNull);
    });

    test('invalid extension is rejected', () async {
      final f = File('tmp_test.txt')..writeAsStringSync('x');
      try {
        final errs = CardEntityValidator.validate(
          id: 1,
          name: 'N',
          number: '1234',
          color: const Color(0xFF000000),
          logoPath: f.path,
        );
        expect(errs['logoPath'], contains('Unsupported extension'));
      } finally {
        await f.delete();
      }
    });

    test('file too large rejected', () async {
      final f = File('tmp_large.jpg');
      final bytes = List.filled(6 * 1024 * 1024, 0); // 6MB
      await f.writeAsBytes(bytes);
      try {
        final errs = CardEntityValidator.validate(
          id: 1,
          name: 'N',
          number: '1234',
          color: const Color(0xFF000000),
          logoPath: f.path,
        );
        expect(errs['logoPath'], contains('too large'));
      } finally {
        await f.delete();
      }
    });

    test('valid image file passes', () async {
      final f = File('tmp_ok.png');
      await f.writeAsBytes([0, 1, 2]);
      try {
        final errs = CardEntityValidator.validate(
          id: 1,
          name: 'N',
          number: '1234',
          color: const Color(0xFF000000),
          logoPath: f.path,
        );
        expect(errs, isEmpty);
      } finally {
        await f.delete();
      }
    });

    test('rawBarcodeSvg validation', () {
      var errs = CardEntityValidator.validate(
        id: 1,
        name: 'N',
        number: '1234',
        color: const Color(0xFF000000),
        rawBarcodeSvg: '<svg></svg>',
      );
      expect(errs, isEmpty);

      errs = CardEntityValidator.validate(
        id: 1,
        name: 'N',
        number: '1234',
        color: const Color(0xFF000000),
        rawBarcodeSvg: '<div></div>',
      );
      expect(errs['rawBarcodeSvg'], isNotNull);
    });
  });
}
