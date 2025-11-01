import 'package:objectbox/objectbox.dart';

@Entity()
class CardModel {
  @Id()
  int id;

  @Index()
  String name;

  String? label;

  @Index()
  String number;

  String? logoPath;

  String? rawBarcodeSvg;

  String? frontPath;

  String? backPath;

  String? note;

  int colorValue;

  CardModel({
    required this.id,
    required this.name,
    required this.number,
    required this.colorValue,
    this.label,
    this.logoPath,
    this.rawBarcodeSvg,
    this.frontPath,
    this.backPath,
    this.note,
  });
}
