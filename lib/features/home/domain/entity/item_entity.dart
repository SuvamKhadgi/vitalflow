import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity; // Available quantity from backend
  final String type;
  final String subType;
  final String image;
  int cartQuantity; // Quantity in cart (defaults to 0)

  ItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.type,
    required this.subType,
    required this.image,
    this.cartQuantity = 0, // Default to 0 if not in cart
  });

  ItemEntity copyWith({
    int? cartQuantity,
  }) {
    return ItemEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      type: type,
      subType: subType,
      image: image,
      cartQuantity: cartQuantity ?? this.cartQuantity,
    );
  }
Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'item_name': name,
      'description': description,
      'item_price': price,
      'item_quantity': quantity,
      'item_type': type,
      'sub_item_type': subType,
      'image': image,
    };
  }
  @override
  List<Object> get props => [
        id,
        name,
        description,
        price,
        quantity,
        type,
        subType,
        image,
        cartQuantity
      ];
}
