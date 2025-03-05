import 'package:equatable/equatable.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';

class CartEntity extends Equatable {
  final String? id;
  final String userId;
  final List<CartItemEntity> items;

  const CartEntity({
    this.id,
    required this.userId,
    required this.items,
  });
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, userId, items];
}

class CartItemEntity extends Equatable {
  final String itemId;
  final int quantity;

  const CartItemEntity({
    required this.itemId,
    required this.quantity,
  });
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'quantity': quantity,
    };
  }

  @override
  List<Object> get props => [itemId, quantity];
}