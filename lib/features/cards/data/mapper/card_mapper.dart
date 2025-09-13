import 'dart:ui';

import 'package:card_hive/features/cards/data/models/card_model.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';

class CardMapper {
  static CardEntity fromModel(CardModel model) => CardEntity(
    id: model.id,
    name: model.name,
    number: model.number,
    color: Color(model.colorValue),
    label: model.label,
    logoPath: model.logoPath,
    note: model.note,
  );

  static CardModel toModel(CardEntity entity) => CardModel(
    id: entity.id,
    name: entity.name,
    number: entity.number,
    colorValue: entity.color.toARGB32(),
    label: entity.label,
    logoPath: entity.logoPath,
    note: entity.note,
  );
}
