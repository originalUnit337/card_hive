// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardEntity _$CardEntityFromJson(Map<String, dynamic> json) => CardEntity(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  number: json['number'] as String,
  color: _colorFromJson((json['color'] as num).toInt()),
  label: json['label'] as String?,
  logoPath: json['logoPath'] as String?,
  rawBarcodeSvg: json['rawBarcodeSvg'] as String?,
  backPath: json['backPath'] as String?,
  frontPath: json['frontPath'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$CardEntityToJson(CardEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'label': instance.label,
      'number': instance.number,
      'logoPath': instance.logoPath,
      'rawBarcodeSvg': instance.rawBarcodeSvg,
      'backPath': instance.backPath,
      'frontPath': instance.frontPath,
      'note': instance.note,
      'color': _colorToJson(instance.color),
    };
