import 'package:hive/hive.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';

part 'cart_hive_model.g.dart';

@HiveType(typeId: 2)
class CartHiveModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final List<CartItemHiveModel> items;

  CartHiveModel({
    this.id,
    required this.userId,
    required this.items,
  });

  factory CartHiveModel.fromEntity(CartEntity entity) {
    return CartHiveModel(
      id: entity.id,
      userId: entity.userId,
      items: entity.items.map((item) => CartItemHiveModel.fromEntity(item)).toList(),
    );
  }

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }
}

@HiveType(typeId: 3)
class CartItemHiveModel {
  @HiveField(0)
  final String itemId;
  @HiveField(1)
  final int quantity;

  CartItemHiveModel({
    required this.itemId,
    required this.quantity,
  });

  factory CartItemHiveModel.fromEntity(CartItemEntity entity) {
    return CartItemHiveModel(
      itemId: entity.itemId,
      quantity: entity.quantity,
    );
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      itemId: itemId,
      quantity: quantity,
    );
  }
}