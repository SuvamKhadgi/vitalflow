import 'package:json_annotation/json_annotation.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';

part 'cart_dto.g.dart';

@JsonSerializable()
class CartDto {
  @JsonKey(name: '_id')
  final String? id;
  final String userId;
  final List<CartItemDto> items;

  CartDto({this.id, required this.userId, required this.items});

  factory CartDto.fromJson(Map<String, dynamic> json) {
    print('CartDto parsing: $json'); // Debug
    return _$CartDtoFromJson(json);
  }
  Map<String, dynamic> toJson() => _$CartDtoToJson(this);

  CartEntity toEntity() => CartEntity(id: id, userId: userId, items: items.map((dto) => dto.toEntity()).toList());
}

@JsonSerializable()
class CartItemDto {
  @JsonKey(name: 'itemId', fromJson: _itemIdFromJson)
  final String itemId; // Still a String, but extracted from Map
  final int quantity;

  CartItemDto({required this.itemId, required this.quantity});

  factory CartItemDto.fromJson(Map<String, dynamic> json) {
    print('CartItemDto parsing: $json'); // Debug
    return _$CartItemDtoFromJson(json);
  }
  Map<String, dynamic> toJson() => _$CartItemDtoToJson(this);

  CartItemEntity toEntity() => CartItemEntity(itemId: itemId, quantity: quantity);
}

String _itemIdFromJson(dynamic value) {
  if (value is String) return value;
  if (value is Map<String, dynamic> && value['_id'] is String) {
    print('Extracting itemId from populated item: ${value['_id']}'); // Debug
    return value['_id'] as String;
  }
  throw Exception('Invalid itemId format: $value');
}