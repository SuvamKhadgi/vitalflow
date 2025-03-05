import 'package:json_annotation/json_annotation.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';

part 'item_dto.g.dart';

@JsonSerializable()
class ItemDto {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'item_name')
  final String name;
  final String description;
  @JsonKey(name: 'item_price')
  final double price;
  @JsonKey(name: 'item_quantity')
  final int quantity;
  @JsonKey(name: 'item_type')
  final String type;
  @JsonKey(name: 'sub_item_type')
  final String subType;
  final String image;

  ItemDto({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.type,
    required this.subType,
    required this.image,
  });

  factory ItemDto.fromJson(Map<String, dynamic> json) => _$ItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ItemDtoToJson(this);

  // Convert to entity (initialize cartQuantity to 0)
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
      cartQuantity: 0, // Default cart quantity
    );
  }
}