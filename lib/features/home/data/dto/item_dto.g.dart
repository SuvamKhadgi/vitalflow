// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemDto _$ItemDtoFromJson(Map<String, dynamic> json) => ItemDto(
      id: json['_id'] as String,
      name: json['item_name'] as String,
      description: json['description'] as String,
      price: (json['item_price'] as num).toDouble(),
      quantity: (json['item_quantity'] as num).toInt(),
      type: json['item_type'] as String,
      subType: json['sub_item_type'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$ItemDtoToJson(ItemDto instance) => <String, dynamic>{
      '_id': instance.id,
      'item_name': instance.name,
      'description': instance.description,
      'item_price': instance.price,
      'item_quantity': instance.quantity,
      'item_type': instance.type,
      'sub_item_type': instance.subType,
      'image': instance.image,
    };
