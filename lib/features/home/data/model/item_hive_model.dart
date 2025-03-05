import 'package:hive/hive.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';

part 'item_hive_model.g.dart';

@HiveType(typeId: 1)
class ItemHiveModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final int quantity;
  @HiveField(5)
  final String type;
  @HiveField(6)
  final String subType;
  @HiveField(7)
  final String image;

  ItemHiveModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.type,
    required this.subType,
    required this.image,
  });

  factory ItemHiveModel.fromEntity(ItemEntity entity) {
    return ItemHiveModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      quantity: entity.quantity,
      type: entity.type,
      subType: entity.subType,
      image: entity.image,
    );
  }

  ItemEntity toEntity() {
    return ItemEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      type: type,
      subType: subType,
      image: image,
    );
  }
}