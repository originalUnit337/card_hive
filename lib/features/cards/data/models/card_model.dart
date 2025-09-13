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
  String? note;
  int colorValue;

  CardModel({
    required this.id,
    required this.name,
    this.label,
    required this.number,
    this.logoPath,
    this.note,
    required this.colorValue,
  });
}
